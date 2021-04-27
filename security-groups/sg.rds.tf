## RDS Database PostGreSQL
# out to
resource "aws_security_group" "egress_to_rds_cluster" {
  name        = "${local.name}-egress-to-rds-cluster"
  description = "Egress to RDS Cluster Security Group"
  vpc_id      = local.vpc_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name}-egress-to-rds-cluster"
    },
  )
}

resource "aws_security_group_rule" "egress_to_postgres" {
  security_group_id = aws_security_group.egress_to_rds_cluster.id
  cidr_blocks       = local.db_subnets_cidr_blocks
  type              = "egress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
}
