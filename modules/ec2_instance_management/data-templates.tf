## Module
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "template_file" "ec2_assume_role_template" {
  template = file("${path.module}/templates/iam/ec2_assume_role.tpl")
  vars     = {}
}

data "template_file" "ec2_role_policy" {
  template = file("${path.module}/templates/iam/ec2_role_policy.tpl")

  vars = {
    aws_account_id = data.aws_caller_identity.current.id
    region         = data.aws_region.current.name
  }
}

data "template_file" "ec2_user_data_template" {
  template = file("${path.module}/templates/ec2/ec2_user_data.tpl")

  vars = {
    aws_account_id          = data.aws_caller_identity.current.id
    region                  = data.aws_region.current.name
    environment_name        = var.environment_name
    app_name                = var.ec2_conf["app_name"]
    jira_data_volume_id     = var.jira_conf["jira_data_volume_id"]
    jira_db_endpoint        = var.jira_conf["jira_db_endpoint"]
    jira_db_master_username = var.jira_conf["jira_db_master_username"]
  }
}

data "template_file" "ec2_s3_access_policy" {
  template = file("${path.module}/templates/iam/ec2_s3_access_policy.tpl")

  vars = {
    prod_bucket_kms_arn = "arn:aws:kms:eu-west-2:172219029581:key/f70f9bbc-d943-4c5c-914b-ea37be341590"
    prod_bucket_arn     = "arn:aws:s3:::eu-west-2-cr-jira-prod-data"
  }
}
