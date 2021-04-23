## RDS Database PostGreSQL
# in
resource "aws_security_group" "ingress_to_rds_cluster" {
  name        = "${local.name}-ingress-to-rds-cluster"
  description = "RDS Cluster Security Group"
  vpc_id      = local.vpc_id
  tags = merge(
  var.tags,
  {
    "Name" = "${local.name}-ingress-to-rds-cluster"
  },
  )
}

resource "aws_security_group_rule" "ingress_to_postgres" {
  security_group_id        = aws_security_group.ingress_to_rds_cluster.id
  source_security_group_id = aws_security_group.egress_to_rds_cluster.id
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
}

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
  security_group_id        = aws_security_group.egress_to_rds_cluster.id
  source_security_group_id = aws_security_group.ingress_to_rds_cluster.id
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
}
