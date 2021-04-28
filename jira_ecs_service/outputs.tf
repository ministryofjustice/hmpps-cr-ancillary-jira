# jira ecs
output "alb" {
  value = aws_lb.alb
}

output "aws_lb_listeners" {
  value = {
    https_listener = aws_lb_listener.https_listener
    http_listener   = aws_lb_listener.http_listener
  }
}

output "aws_lb_target_group" {
  value = aws_lb_target_group.http
}

output "aws_route53_record" {
  value = aws_route53_record.public_dns
}

output "aws_cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.jira_service_log_group
}

output "aws_service_discovery_service" {
  value = aws_service_discovery_service.jira_web_svc_record
}

output "aws_ecs_task_definition" {
  value = aws_ecs_task_definition.jira_service
}

//output "aws_ecs_service" {
//  value = aws_ecs_service.jira_service
//}

output "aws_iam_role_jira_execute" {
  value = aws_iam_role.jira_execute
}

output "iam_jira_execute_policy" {
  value = aws_iam_role_policy.jira_execute_policy
}

output "aws_iam_role_jira_task" {
  value = aws_iam_role.jira_task
}
