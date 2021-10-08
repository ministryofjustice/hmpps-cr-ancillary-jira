resource "aws_cloudwatch_log_group" "jira_service_log_group" {
  name              = "${local.jira_service_name}-pri-cwl"
  retention_in_days = var.cloudwatch_log_retention
  kms_key_id        = local.kms_key_arn
  tags              = merge(var.tags, map("Name", "${local.jira_service_name}-pri-cwl"))
}
