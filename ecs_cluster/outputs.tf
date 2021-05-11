output "ecs_cluster" {
  value = aws_ecs_cluster.this
}

output "ecs_cluster_private_namespace" {
  value = aws_service_discovery_private_dns_namespace.ecs_namespace
}
