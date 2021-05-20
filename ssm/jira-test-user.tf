## Jira Test User
locals {
  jira_test_user = {
    username  = "JiraServiceManagement.TestUser"
    full_name = "JiraServiceManagement TestUser"
    email     = "UPDATE_ME+${var.environment_name}_JiraServiceManagement.TestUser@digital.justice.gov.uk"

  }
}

resource "random_password" "jira_test_user_password" {
  length           = 100
  special          = true
  override_special = "!$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "jira_test_user_password" {
  name        = "/${var.environment_name}/jira_test/jira_test_user_password"
  description = "JIRA Test User - Password"
  type        = "SecureString"
  value       = random_password.jira_test_user_password.result
  tags        = merge(var.tags, { "Name" = "/${var.environment_name}/jira_test/jira_test_user_password" })

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "jira_test_username" {
  name        = "/${var.environment_name}/jira_test/jira_test_username"
  description = "JIRA Test User - Username"
  type        = "String"
  value       = local.jira_test_user["username"]
  tags        = merge(var.tags, { "Name" = "/${var.environment_name}/jira_test/jira_test_username" })

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "jira_test_full_name" {
  name        = "/${var.environment_name}/jira_test/jira_test_full_name"
  description = "JIRA Test User - Full name"
  type        = "String"
  value       = local.jira_test_user["full_name"]
  tags        = merge(var.tags, { "Name" = "/${var.environment_name}/jira_test/jira_test_full_name" })

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "jira_test_user_email" {
  name        = "/${var.environment_name}/jira_test/jira_test_user_email"
  description = "JIRA Test User - Full name"
  type        = "String"
  value       = local.jira_test_user["email"]
  tags        = merge(var.tags, { "Name" = "/${var.environment_name}/jira_test/jira_test_user_email" })

  lifecycle {
    ignore_changes = [value]
  }
}
