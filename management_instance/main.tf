module "management_instance" {
  source = "../modules/ec2_instance_management"

  environment_name = var.environment_name
  tags             = var.tags
  region           = var.region
  ec2_conf = {
    app_name      = "management"
    ami_id        = local.ami_id
    instance_type = "t3.xlarge"
    subnet_id     = local.private_subnet_ids[0]
    //    iam_instance_profile        = ""
    associate_public_ip_address = false
    security_groups             = local.jira_ecs_security_groups
    //    user_data                   = ""
    monitoring       = true
    root_device_size = 50
  }
  jira_conf = {
    jira_data_volume_id       = local.efs["id"]
    jira_data_dns_name        = local.efs["dns_name"]
    jira_db_endpoint          = local.rds_cluster["endpoint"]
    jira_db_master_username   = local.rds_cluster["master_username"]
    jira_cloudwatch_log_group = ""
  }
}
