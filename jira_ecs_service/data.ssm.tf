data "terraform_remote_state" "ssm" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "ssm/terraform.tfstate"
    region = var.region
  }
}

data "aws_ssm_parameter" "jira_db_user" {
  name = local.ssm_path.jira_db_user
}


locals {
  ssm_path = {
    jira_db_user = data.terraform_remote_state.ssm.outputs.parameter["jira_db_user"]["name"]
  }
  ssm_value = {
    jira_db_user = data.aws_ssm_parameter.jira_db_user.value
  }
  ssm_arn = {
    jira_admin_password   = data.terraform_remote_state.ssm.outputs.parameter["jira_admin_password"]["arn"],
    jira_db_user_password = data.terraform_remote_state.ssm.outputs.parameter["jira_db_user_password"]["arn"]
  }
}
