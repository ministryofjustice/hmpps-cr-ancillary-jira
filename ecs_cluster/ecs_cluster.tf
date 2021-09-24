resource "aws_cloudwatch_log_group" "this" {
  name              = "${local.name}-ecs"
  retention_in_days = 14
  tags              = merge(var.tags, map("Name", "${local.name}-ecs"))
}


resource "aws_ecs_cluster" "this" {
  name = var.environment_name

  capacity_providers = ["FARGATE"]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.tags, map("Name", "${local.name}-ecs"))

  configuration {
    execute_command_configuration {
      kms_key_id = local.kms_key_arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.this.name
      }
    }
  }
}

# Create a private service namespace to allow tasks to discover & communicate with each other
# without using load balancers, or building per env fqdns
resource "aws_service_discovery_private_dns_namespace" "ecs_namespace" {
  name        = var.ecs_cluster_namespace_name
  description = "Private namespace for shared ECS Cluster tasks"
  vpc         = local.vpc_id

  tags = merge(var.tags, map("Name", var.ecs_cluster_namespace_name))
}
