## Module

### don't need
//data "template_file" "efs_kms_policy" {
//  template = file("${path.module}/templates/kms/kms_key_mgmt_policy.tpl")
//
//  vars = {
//    aws_account_id = data.aws_caller_identity.current.account_id
//  }
//}

data "template_file" "ec2_assume_role_template" {
  template = file("${path.module}/templates/iam/ec2_assume_role.tpl")
  vars     = {}
}
//
//data "template_file" "backup_assume_role_template" {
//  template = file("${path.module}/templates/iam/backup_assume_role.tpl")
//  vars     = {}
//}
//
data "template_file" "jira_role_policy_template" {
  template = file("${path.module}/templates/iam/jira_role.tpl")

  vars = {
    aws_account_id = var.jira_data["aws_account_id"]
    region         = var.jira_data["region"]
  }
}

//data "template_file" "jira_user_data_template" {
//  template = file("${path.module}/templates/ec2/jira_user_data.tpl")
//
//  vars = {
//    aws_account_id              = var.jira_data["aws_account_id"]
//    region                      = var.jira_data["region"]
//    environment_name            = var.jira_data["environment_name"]
//    app_name                    = var.jira_data["app_name"]
//
//    jira_version                = var.jira_conf["jira_version"]
//    jira_filename               = var.jira_conf["jira_filename"]
//    mysql_connector_version     = var.jira_conf["mysql_connector_version"]
//    jira_user                   = var.jira_conf["jira_user"]
//    jira_group                  = var.jira_conf["jira_group"]
//    jira_smtp_user              = var.jira_data["jira_smtp_user"]
//    jira_smtp_password_ssmparam = var.jira_data["jira_smtp_password_ssmparam"]
//    jira_smtp_endpoint          = var.jira_data["jira_smtp_endpoint"]
//    jira_smtp_port              = var.jira_data["jira_smtp_port"]
//    jira_smtp_auth              = var.jira_conf["jira_smtp_auth"]
//    jira_smtp_starttls          = var.jira_conf["jira_smtp_starttls"]
//    jira_db_name                = var.jira_conf["db_name"]
//
//    jira_data_volume_id         = var.jira_conf["jira_data_volume_id"]
//    db_master_user              = var.jira_conf["db_master_username"]
//    jira_db_endpoint            = var.jira_data["jira_db_endpoint"]
//    jira_external_endpoint      = aws_lb.jira_lb.dns_name
//    jira_cloudwatch_log_group   = aws_cloudwatch_log_group.jira_log_group.name
//  }
//}

data "template_file" "jira_user_data_template" {
  template = file("${path.module}/templates/ec2/jira_ec2_user_data.tpl")

  vars = {
    region                    = var.jira_data["region"]
    environment_name          = var.environment_name
    app_name                  = var.jira_data["app_name"]
    aws_account_id            = var.jira_data["aws_account_id"]
    jira_data_volume_id       = var.jira_data["jira_data_volume_id"]
    jira_db_endpoint          = var.jira_data["jira_db_endpoint"]
    jira_cloudwatch_log_group = aws_cloudwatch_log_group.jira_log_group.name
    jira_db_master_username   = var.jira_data["jira_db_master_username"]
    alb_fqdn                  = aws_route53_record.alb_public_dns.fqdn

    sharedhome_path             = var.jira_conf["sharedhome_path"]
    shared_home_volume_name     = var.jira_conf["shared_home_volume_name"]
    shared_home_volume_root_dir = var.jira_conf["shared_home_volume_root_dir"]
    jira_config_path            = var.jira_conf["jira_config_path"]
    jira_config_volume_name     = var.jira_conf["jira_config_volume_name"]
    jira_config_volume_root_dir = var.jira_conf["jira_config_volume_root_dir"]
  }
}

# Hack to merge additional tag into existing map and convert to list for use with asg tags input
data "null_data_source" "tags" {
  count = length(keys(var.tags))

  inputs = {
    key                 = element(keys(var.tags), count.index)
    value               = element(values(var.tags), count.index)
    propagate_at_launch = true
  }
}
