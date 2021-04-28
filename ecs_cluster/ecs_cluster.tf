resource "aws_ecs_cluster" "this" {
  name = var.environment_name

  capacity_providers = ["FARGATE"]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.tags, map("Name", "${local.name}-ecs"))
}

# Create a private service namespace to allow tasks to discover & communicate with each other
# without using load balancers, or building per env fqdns
resource "aws_service_discovery_private_dns_namespace" "ecs_namespace" {
  name        = var.ecs_cluster_namespace_name
  description = "Private namespace for shared ECS Cluster tasks"
  vpc         = local.vpc_id

  tags = merge(var.tags, map("Name", var.ecs_cluster_namespace_name))
}
