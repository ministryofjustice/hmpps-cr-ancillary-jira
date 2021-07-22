# Endpoint HealthCheck using Route53
# London Region not support yet, so metrics are not yet publised, can be enabled at later stage
resource "aws_route53_health_check" "jira_ec2" {
  fqdn              = local.jira_ec2["aws_route53_record"]["fqdn"]
  port              = 443
  type              = "HTTPS"
  resource_path     = "/login.jsp"
  failure_threshold = 3
  request_interval  = 30
  regions           = ["us-east-1", "eu-west-1", "ap-southeast-1"]
  tags              = local.tags
}

# London Region not support yet, so metrics are not yet publised, can be enabled at later stage
/*
resource "aws_cloudwatch_metric_alarm" "jira_ec2" {
  alarm_name          = "${local.common_name}_jira_ec2_endpoint_status--critical"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  alarm_description   = "Route53 health check status for ${local.jira_ec2["aws_route53_record"]["fqdn"]}"
  alarm_actions       = [local.sns_alarm_notification_arn]
  ok_actions          = [local.sns_alarm_notification_arn]

  dimensions = {
    HealthCheckId = aws_route53_health_check.jira_ec2.id
  }

  tags                = local.tags
}
*/
