# Jira RDS Cluster

## Module
This RDS Cluster uses the module from the official Terraform module repository:
https://registry.terraform.io/modules/terraform-aws-modules/rds-aurora/aws/latest

## Outputs

Map `rds_cluster` with following attributes

| Name | Description |
|------|-------------|
| <a name="output_enhanced_monitoring_iam_role_arn"></a> [enhanced\_monitoring\_iam\_role\_arn](#output\_enhanced\_monitoring\_iam\_role\_arn) | The Amazon Resource Name (ARN) specifying the enhanced monitoring role |
| <a name="output_enhanced_monitoring_iam_role_name"></a> [enhanced\_monitoring\_iam\_role\_name](#output\_enhanced\_monitoring\_iam\_role\_name) | The name of the enhanced monitoring role |
| <a name="output_enhanced_monitoring_iam_role_unique_id"></a> [enhanced\_monitoring\_iam\_role\_unique\_id](#output\_enhanced\_monitoring\_iam\_role\_unique\_id) | Stable and unique string identifying the enhanced monitoring role |
| <a name="output_arn"></a> [arn](#output\_arn) | The ID of the cluster |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | Name for an automatically created database on cluster creation |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The cluster endpoint |
| <a name="output_engine_version"></a> [engine\_version](#output\_engine\_version) | The cluster engine version |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | Route53 hosted zone id of the created cluster |
| <a name="output_id"></a> [id](#output\_id) | The ID of the cluster |
| <a name="output_instance_endpoints"></a> [instance\_endpoints](#output\_instance\_endpoints) | A list of all cluster instance endpoints |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | A list of all cluster instance ids |
| <a name="output_master_password"></a> [master\_password](#output\_master\_password) | The master password |
| <a name="output_master_username"></a> [master\_username](#output\_master\_username) | The master username |
| <a name="output_port"></a> [port](#output\_port) | The port |
| <a name="output_reader_endpoint"></a> [reader\_endpoint](#output\_reader\_endpoint) | The cluster reader endpoint |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | The Resource ID of the cluster |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The security group ID of the cluster |

These are as a map:
```terraform

data "terraform_remote_state" "jira_rds_cluster" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "jira_rds_cluster/terraform.tfstate"
    region = var.region
  }
}

locals {
  endpoint = data.terraform_remote_state.jira_rds_cluster.outputs.rds_cluster["endpoint"]  
}

```


Below is a list of the variables from the [variables.tf](https://github.com/terraform-aws-modules/terraform-aws-rds-aurora/blob/3e08cb6b164c869a87cf89beeb032b95eafe5926/variables.tf)

```js
create_cluster
create_security_group
name
subnets
replica_count
allowed_security_groups
allowed_cidr_blocks
vpc_id
instance_type_replica
instance_type
publicly_accessible
database_name
username
create_random_password
password
is_primary_cluster
final_snapshot_identifier_prefix
skip_final_snapshot
deletion_protection
backup_retention_period
preferred_backup_window
preferred_maintenance_window
port
apply_immediately
monitoring_interval
allow_major_version_upgrade
auto_minor_version_upgrade
db_parameter_group_name
db_cluster_parameter_group_name
scaling_configuration
snapshot_identifier
storage_encrypted
kms_key_id
engine
engine_version
enable_http_endpoint
replica_scale_enabled
replica_scale_max
replica_scale_min
replica_scale_cpu
replica_scale_connections
replica_scale_in_cooldown
replica_scale_out_cooldown
tags
cluster_tags
security_group_tags
performance_insights_enabled
performance_insights_kms_key_id
iam_database_authentication_enabled
enabled_cloudwatch_logs_exports
global_cluster_identifier
engine_mode
replication_source_identifier
source_region
vpc_security_group_ids
db_subnet_group_name
predefined_metric_type
backtrack_window
copy_tags_to_snapshot
iam_roles
security_group_description
ca_cert_identifier
instances_parameters
s3_import
create_monitoring_role
monitoring_role_arn
iam_role_name
iam_role_use_name_prefix
iam_role_description
iam_role_path
iam_role_managed_policy_arns
iam_role_permissions_boundary
iam_role_force_detach_policies
iam_role_max_session_duration
```
