resource "aws_db_subnet_group" "jira_db_subnet_group" {
  description = "title(${local.name}) JIRA DB Subnet Group"
  subnet_ids  = local.db_subnet_ids
  name        = "${local.name}-jiradb-pri-net"
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name}-jiradb-pri-net"
    },
  )
}

module "jira_db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 4.2"

  name                  = local.name
  engine                = "aurora-postgresql"
  engine_version        = "11.9"
  instance_type         = "db.r5.large"
  instance_type_replica = "db.t3.medium"

  vpc_id                = data.terraform_remote_state.vpc.outputs.vpc_id
  db_subnet_group_name  = aws_db_subnet_group.jira_db_subnet_group.name
  create_security_group = true
  security_group_description = "Jira DB"
  allowed_cidr_blocks   = local.private_subnets_cidr_blocks

  replica_count                       = 2
  iam_database_authentication_enabled = true
  password                            = local.ssm_value.rds_cluster_master_password
  create_random_password              = false
  username                            = local.ssm_value.rds_cluster_master_username
  kms_key_id                          = local.jira_kms_key_arn

  apply_immediately   = true
  skip_final_snapshot = true

  deletion_protection = false #TODO set true for prod

  db_parameter_group_name         = aws_db_parameter_group.jira_db.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.jira_db.id
  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = var.tags
}

resource "aws_db_parameter_group" "jira_db" {
  name        = "${local.name}-aurora-db-postgres11-parameter-group"
  family      = "aurora-postgresql11"
  description = "${local.name}-aurora-db-postgres11-parameter-group"
  tags        = var.tags
}

resource "aws_rds_cluster_parameter_group" "jira_db" {
  name        = "${local.name}-aurora-postgres11-cluster-parameter-group"
  family      = "aurora-postgresql11"
  description = "${local.name}-aurora-postgres11-cluster-parameter-group"
  tags        = var.tags
}




//create_cluster
//create_security_group
//name
//subnets
//replica_count
//allowed_security_groups
//allowed_cidr_blocks
//vpc_id
//instance_type_replica
//instance_type
//publicly_accessible
//database_name
//username
//create_random_password
//password
//is_primary_cluster
//final_snapshot_identifier_prefix
//skip_final_snapshot
//deletion_protection
//backup_retention_period
//preferred_backup_window
//preferred_maintenance_window
//port
//apply_immediately
//monitoring_interval
//allow_major_version_upgrade
//auto_minor_version_upgrade
//db_parameter_group_name
//db_cluster_parameter_group_name
//scaling_configuration
//snapshot_identifier
//storage_encrypted
//kms_key_id
//engine
//engine_version
//enable_http_endpoint
//replica_scale_enabled
//replica_scale_max
//replica_scale_min
//replica_scale_cpu
//replica_scale_connections
//replica_scale_in_cooldown
//replica_scale_out_cooldown
//tags
//cluster_tags
//security_group_tags
//performance_insights_enabled
//performance_insights_kms_key_id
//iam_database_authentication_enabled
//enabled_cloudwatch_logs_exports
//global_cluster_identifier
//engine_mode
//replication_source_identifier
//source_region
//vpc_security_group_ids
//db_subnet_group_name
//predefined_metric_type
//backtrack_window
//copy_tags_to_snapshot
//iam_roles
//security_group_description
//ca_cert_identifier
//instances_parameters
//s3_import
//create_monitoring_role
//monitoring_role_arn
//iam_role_name
//iam_role_use_name_prefix
//iam_role_description
//iam_role_path
//iam_role_managed_policy_arns
//iam_role_permissions_boundary
//iam_role_force_detach_policies
//iam_role_max_session_duration
