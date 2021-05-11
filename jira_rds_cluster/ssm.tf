resource "aws_ssm_parameter" "database_name" {
  name        = "/${var.environment_name}/jira/database_name"
  description = "JIRA RDS DB Name"
  type        = "String"
  value       = module.jira_db.this_rds_cluster_database_name
  tags        = merge(var.tags, { "Name" = "/${var.environment_name}/jira/database_name" })
}

resource "aws_ssm_parameter" "db_endpoint" {
  name        = "/${var.environment_name}/jira/db_endpoint"
  description = "JIRA RDS DB End Point"
  type        = "String"
  value       = module.jira_db.this_rds_cluster_endpoint
  tags        = merge(var.tags, { "Name" = "/${var.environment_name}/jira/db_endpoint" })
}

resource "aws_ssm_parameter" "db_port" {
  name        = "/${var.environment_name}/jira/db_port"
  description = "JIRA RDS DB Port"
  type        = "String"
  value       = module.jira_db.this_rds_cluster_port
  tags        = merge(var.tags, { "Name" = "/${var.environment_name}/jira/db_port" })
}
