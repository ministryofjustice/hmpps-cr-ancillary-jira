## Module

## ALB
resource "aws_security_group" "ingress_to_jira_lb" {
  name        = "${local.name}-ingress-to-jira-lb"
  description = "JIRA ALB Ingress"
  vpc_id      = local.vpc_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name}-ingress-to-jira-lb"
    },
  )
}

resource "aws_security_group_rule" "jira_lb_https_in_rule" {
  security_group_id = aws_security_group.ingress_to_jira_lb.id
  cidr_blocks       = var.allowed_jira_cidr #["82.39.185.97/32", var.cidr_block, "35.176.14.16/32"] #var.allowed_jira_cidr
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}

resource "aws_security_group_rule" "jira_lb_http_in_rule" {
  security_group_id = aws_security_group.ingress_to_jira_lb.id
  cidr_blocks       = var.allowed_jira_cidr #["82.39.185.97/32", var.cidr_block, "35.176.14.16/32"] #var.allowed_jira_cidr
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

resource "aws_security_group" "egress_from_jira_lb" {
  name        = "${local.name}-egress-from-jira-lb"
  description = "JIRA ALB Egress"
  vpc_id      = local.vpc_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name}-egress-from-jira-lb"
    },
  )
}

resource "aws_security_group_rule" "jira_web_out_rule" {
  security_group_id        = aws_security_group.egress_from_jira_lb.id
  source_security_group_id = aws_security_group.ingress_to_jira.id
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
}

## Jira
resource "aws_security_group" "ingress_to_jira" {
  name        = "${local.name}-ingress-to-jira"
  description = "JIRA Service Ingress"
  vpc_id      = local.vpc_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name}-ingress-to-jira"
    },
  )
}

resource "aws_security_group_rule" "jira_alb_http_in_rule" {
  security_group_id        = aws_security_group.ingress_to_jira.id
  source_security_group_id = aws_security_group.egress_from_jira_lb.id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
}

resource "aws_security_group" "egress_from_jira" {
  name        = "${local.name}-egress-from-jira"
  description = "JIRA Service Egress"
  vpc_id      = local.vpc_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name}-egress-from-jira"
    },
  )
}

resource "aws_security_group_rule" "jira_nfs_out_rule" {
  security_group_id        = aws_security_group.egress_from_jira.id
  source_security_group_id = aws_security_group.ingress_to_efs.id
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "jira_postgres_out_rule" {
  security_group_id = aws_security_group.egress_from_jira.id
  cidr_blocks       = local.db_subnets_cidr_blocks
  type              = "egress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
}

resource "aws_security_group_rule" "jira_http_out_rule" {
  security_group_id = aws_security_group.egress_from_jira.id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

resource "aws_security_group_rule" "jira_https_out_rule" {
  security_group_id = aws_security_group.egress_from_jira.id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}

resource "aws_security_group_rule" "jira_smtps_out_rule" {
  security_group_id = aws_security_group.egress_from_jira.id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
  from_port         = 465
  to_port           = 465
  protocol          = "tcp"
}
