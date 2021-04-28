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
    failure_threshold = 1
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
      region           = var.region
      aws_account_id   = data.aws_caller_identity.current.account_id
      environment_name = var.environment_name
      container_name   = local.app_name
      image_url        = var.jira_ecs_conf["image"]
      image_version    = var.jira_ecs_conf["image_version"]
      service_port     = var.jira_ecs_conf["service_port"]
      log_group_name   = aws_cloudwatch_log_group.jira_service_log_group.name
    }
  )
  tags = merge(var.tags, map("Name", "${local.jira_service_name}-ecs"))
}



resource "aws_ecs_service" "jira_service" {
  name            = "${local.app_name}-service"
  cluster         = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster["id"]
  task_definition = aws_ecs_task_definition.jira_service.arn

  desired_count = 3
  launch_type   = "FARGATE"

  health_check_grace_period_seconds = 1

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

  lifecycle {
    ignore_changes = [desired_count]
  }
  tags = merge(var.tags, map("Name", "${local.app_name}-service"))
}
