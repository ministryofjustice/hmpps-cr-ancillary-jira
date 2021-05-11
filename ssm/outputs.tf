output "parameter" {
  value = {
    jira_admin_password = {
      arn    = aws_ssm_parameter.jira_admin_password.arn,
      id     = aws_ssm_parameter.jira_admin_password.id,
      key_id = aws_ssm_parameter.jira_admin_password.key_id,
      name   = aws_ssm_parameter.jira_admin_password.name
    },
    rds_cluster_master_password = {
      arn    = aws_ssm_parameter.rds_cluster_master_password.arn,
      id     = aws_ssm_parameter.rds_cluster_master_password.id,
      key_id = aws_ssm_parameter.rds_cluster_master_password.key_id,
      name   = aws_ssm_parameter.rds_cluster_master_password.name
    },
    rds_cluster_master_username = {
      arn    = aws_ssm_parameter.rds_cluster_master_username.arn,
      id     = aws_ssm_parameter.rds_cluster_master_username.id,
      key_id = aws_ssm_parameter.rds_cluster_master_username.key_id,
      name   = aws_ssm_parameter.rds_cluster_master_username.name
    },
    jira_db_user_password = {
      arn    = aws_ssm_parameter.jira_db_user_password.arn,
      id     = aws_ssm_parameter.jira_db_user_password.id,
      key_id = aws_ssm_parameter.jira_db_user_password.key_id,
      name   = aws_ssm_parameter.jira_db_user_password.name
    },
    jira_db_user = {
      arn    = aws_ssm_parameter.jira_db_user.arn,
      id     = aws_ssm_parameter.jira_db_user.id,
      key_id = aws_ssm_parameter.jira_db_user.key_id,
      name   = aws_ssm_parameter.jira_db_user.name
    }
  }
}
