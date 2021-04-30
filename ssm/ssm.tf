resource "random_password" "jira_admin_password" {
  length  = 32
  special = false
}

resource "aws_ssm_parameter" "jira_admin_password" {
  name        = "/${var.environment_name}/jira/jira_admin_password"
  description = "JIRA Admin Password"
  type        = "SecureString"
  value       = random_password.jira_admin_password.result

  tags = merge(
    var.tags,
    {
      "Name" = "/${var.environment_name}/jira/jira_admin_password"
    },
  )

  lifecycle {
    ignore_changes = [value]
  }
}

##
## For Aurora PostgreSQL
## it must contain 8–128 printable ASCII characters.
## It can't contain /, ", @, or a space.
## But in practice can't be over 99 or this error is produced ¯\_(ツ)_/¯
## "Error: error creating RDS cluster: InvalidParameterValue: The parameter MasterUserPassword is not a valid password because it is longer than 99 characters."

resource "random_password" "rds_cluster_master_password" {
  length           = 99
  special          = true
  override_special = "!$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "rds_cluster_master_password" {
  name        = "/${var.environment_name}/jira/rds_cluster_master_password"
  description = "JIRA RDS Cluster Master Password"
  type        = "SecureString"
  value       = random_password.rds_cluster_master_password.result
  tags        = merge(var.tags, { "Name" = "/${var.environment_name}/jira/rds_cluster_master_password" })

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "rds_cluster_master_username" {
  name        = "/${var.environment_name}/jira/rds_cluster_master_username"
  description = "JIRA RDS Cluster Master Password"
  type        = "String"
  value       = "root"
  tags        = merge(var.tags, { "Name" = "/${var.environment_name}/jira/rds_cluster_master_password" })

  lifecycle {
    ignore_changes = [value]
  }
}

## Jira Database User
resource "random_password" "jira_db_user_password" {
  length           = 99
  special          = true
  override_special = "!$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "jira_db_user_password" {
  name        = "/${var.environment_name}/jira/jira_db_user_password"
  description = "JIRA DB User Password"
  type        = "SecureString"
  value       = random_password.jira_db_user_password.result
  tags        = merge(var.tags, { "Name" = "/${var.environment_name}/jira/jira_db_user_password" })

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "jira_db_user" {
  name        = "/${var.environment_name}/jira/jira_db_user"
  description = "JIRA RDS Cluster Master Password"
  type        = "String"
  value       = "jira"
  tags        = merge(var.tags, { "Name" = "/${var.environment_name}/jira/jira_db_user" })

  lifecycle {
    ignore_changes = [value]
  }
}
