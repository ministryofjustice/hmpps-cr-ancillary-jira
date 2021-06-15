locals {
  common_name                = var.environment_name
  sns_alarm_notification_arn = data.terraform_remote_state.monitoring.outputs.aws_sns_topic_alarm_notification["arn"]
  jira_ec2                   = data.terraform_remote_state.jira_ec2.outputs.jira_ec2
  //  db_instance_id             = data.terraform_remote_state.database.outputs.database_info["instance_id"]
  tags = var.tags
}
