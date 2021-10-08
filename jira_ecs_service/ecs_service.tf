# Create a service record in the ecs cluster's private namespace
resource "aws_service_discovery_service" "jira_web_svc_record" {
  name = local.app_name
  dns_config {
    namespace_id = local.namespace_id
    dns_records {
      ttl  = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }
  health_check_custom_config {
    failure_threshold = 10
  }
}

resource "aws_ecs_task_definition" "jira_service" {
  family             = "${local.jira_service_name}-ecs"
  task_role_arn      = aws_iam_role.jira_task.arn
  execution_role_arn = aws_iam_role.jira_execute.arn

  network_mode             = "awsvpc"
  memory                   = var.jira_ecs_conf["memory"]
  cpu                      = var.jira_ecs_conf["cpu"]
  requires_compatibilities = ["FARGATE"]
  container_definitions = templatefile("${path.module}/templates/ecs/task_definition.tpl",
    {
      region                  = var.region
      aws_account_id          = data.aws_caller_identity.current.account_id
      environment_name        = var.environment_name
      container_name          = local.app_name
      image_url               = var.jira_ecs_conf["image"]
      image_version           = var.jira_ecs_conf["image_version"]
      service_port            = var.jira_ecs_conf["service_port"]
      ehcache_listener_port   = var.jira_ecs_conf["ehcache_listener_port"]
      log_group_name          = aws_cloudwatch_log_group.jira_service_log_group.name
      alb_fqdn                = aws_route53_record.alb_public_dns.fqdn
      jc_login_duration       = var.jira_conf["login_duration"]
      jira_db_endpoint        = local.jira_db_endpoint
      jira_db_user            = local.ssm_value.jira_db_user
      jira_db_user_password   = local.ssm_arn.jira_db_user_password
      jira_db_driver          = var.jira_conf["jira_db_driver"]
      jira_db_type            = var.jira_conf["jira_db_type"]
      sharedhome_path         = var.jira_conf["sharedhome_path"]
      shared_home_volume_name = var.jira_conf["shared_home_volume_name"]
      jira_config_path        = var.jira_conf["jira_config_path"]
      jira_config_volume_name = var.jira_conf["jira_config_volume_name"]
    }
  )
  volume {
    name = var.jira_conf["shared_home_volume_name"]
    efs_volume_configuration {
      file_system_id     = local.efs["id"]
      root_directory     = var.jira_conf["shared_home_volume_root_dir"]
      transit_encryption = "ENABLED"
    }
  }

//  volume {
//    name = var.jira_conf["jira_config_volume_name"]
//    efs_volume_configuration {
//      file_system_id     = local.efs["id"]
//      root_directory     = var.jira_conf["jira_config_volume_root_dir"]
//      transit_encryption = "ENABLED"
//    }
//  }
  tags = merge(var.tags, map("Name", "${local.jira_service_name}-ecs"))
}



resource "aws_ecs_service" "jira_service" {
  name            = "${local.app_name}-service"
  cluster         = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster["id"]
  task_definition = aws_ecs_task_definition.jira_service.arn

  desired_count = 1
  //launch_type   = "EC2"
  launch_type   = "FARGATE"

  enable_execute_command = true

  health_check_grace_period_seconds = 600

  load_balancer {
    target_group_arn = aws_lb_target_group.http.arn
    container_name   = local.app_name
    container_port   = 8080
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.jira_web_svc_record.arn
    container_name = local.app_name
  }

  network_configuration {
    subnets         = local.private_subnet_ids
    security_groups = local.jira_ecs_security_groups
  }

  depends_on = [aws_iam_role.jira_task]

  //  lifecycle {
  //    ignore_changes = [desired_count]
  //  }
  tags = merge(var.tags, map("Name", "${local.app_name}-service"))
}
