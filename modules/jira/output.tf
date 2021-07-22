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

output "aws_lb" {
  value = aws_lb.jira_lb
}

output "aws_lb_target_group" {
  value = aws_lb_target_group.jira_lb_target_group
}

output "aws_lb_listener_https" {
  value = aws_lb_listener.internal_lb_https_listener
}

output "aws_lb_listener_http_redirect" {
  value = aws_lb_listener.internal_lb_http_redirect_listener
}
