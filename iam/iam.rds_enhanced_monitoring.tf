# Allows RDS to manage CloudWatch Logs resources for Enhanced Monitoring on your behalf.
resource "aws_iam_role" "rds_enhanced_monitoring" {
  name               = "${local.name}-rds-enhanced-monitoring-iam"
  assume_role_policy = templatefile("${path.module}/templates/iam/monitoring_rds_assume_role.tpl", {})
  description        = "Allows RDS to manage CloudWatch Logs resources for Enhanced Monitoring on your behalf."
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name}-rds-enhanced-monitoring-iam"
    },
  )
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role       = aws_iam_role.rds_enhanced_monitoring.name
}
