## Module

resource "aws_cloudwatch_log_group" "jira_log_group" {
  name              = "${var.jira_data["name"]}-pri-cwl"
  retention_in_days = var.jira_conf["log_retention"]
  tags = merge(
    var.tags,
    {
      "Name" = "${var.jira_data["name"]}-pri-cwl"
    },
  )
}
