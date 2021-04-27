resource "aws_ecs_cluster" "this" {
  name = var.environment_name

  capacity_providers = ["FARGATE"]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}
