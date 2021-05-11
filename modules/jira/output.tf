## Module
output "aws_autoscaling_group" {
  value = aws_autoscaling_group.jira_asg
}

output "aws_route53_record" {
  value = aws_route53_record.alb_public_dns
}

output "aws_cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.jira_log_group
}
