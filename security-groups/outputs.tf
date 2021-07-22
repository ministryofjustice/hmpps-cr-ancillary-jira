output "id" {
  value = {
    egress_to_rds_cluster = aws_security_group.egress_to_rds_cluster.id
    ingress_to_efs        = aws_security_group.ingress_to_efs.id

    ingress_to_jira_lb  = aws_security_group.ingress_to_jira_lb.id
    egress_from_jira_lb = aws_security_group.egress_from_jira_lb.id

    ingress_to_jira  = aws_security_group.ingress_to_jira.id
    egress_from_jira = aws_security_group.egress_from_jira.id
  }
}
