# aws_rds_cluster
output "rds_cluster" {
  value = {
    arn             = module.jira_db.this_rds_cluster_arn
    id              = module.jira_db.this_rds_cluster_id
    resource_id     = module.jira_db.this_rds_cluster_resource_id
    endpoint        = module.jira_db.this_rds_cluster_endpoint
    engine_version  = module.jira_db.this_rds_cluster_engine_version
    reader_endpoint = module.jira_db.this_rds_cluster_reader_endpoint
    database_name   = module.jira_db.this_rds_cluster_database_name
    port            = module.jira_db.this_rds_cluster_port
    master_username = module.jira_db.this_rds_cluster_master_username
    hosted_zone_id  = module.jira_db.this_rds_cluster_hosted_zone_id
    # aws_rds_cluster_instance
    instance_endpoints = module.jira_db.this_rds_cluster_instance_endpoints
    instance_ids       = module.jira_db.this_rds_cluster_instance_ids
    # aws_security_group
    security_group_id = module.jira_db.this_security_group_id
    # Enhanced monitoring role
    enhanced_monitoring_iam_role_name      = module.jira_db.this_enhanced_monitoring_iam_role_name
    enhanced_monitoring_iam_role_arn       = module.jira_db.this_enhanced_monitoring_iam_role_arn
    enhanced_monitoring_iam_role_unique_id = module.jira_db.this_enhanced_monitoring_iam_role_unique_id
  }
}
