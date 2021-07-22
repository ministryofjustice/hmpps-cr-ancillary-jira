## EFS
resource "aws_security_group" "ingress_to_efs" {
  name        = "${local.name}-ingress-to-efs"
  description = "Ingress to EFS SG"
  vpc_id      = local.vpc_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name}-efs"
    },
  )
}

resource "aws_security_group_rule" "jira_ec2_ingress_rule" {
  security_group_id        = aws_security_group.ingress_to_efs.id
  source_security_group_id = aws_security_group.egress_from_jira.id
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
}
