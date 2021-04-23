output "id" {
  value = {
    ingress_to_rds_cluster = aws_security_group.ingress_to_rds_cluster.id
    egress_to_rds_cluster  = aws_security_group.egress_to_rds_cluster.id
    ingress_to_efs         = aws_security_group.ingress_to_efs.id
  }
}
