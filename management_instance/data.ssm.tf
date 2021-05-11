data "terraform_remote_state" "ssm" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "ssm/terraform.tfstate"
    region = var.region
  }
}

data "aws_ssm_parameter" "rds_cluster_master_username" {
  name = local.ssm_path.rds_cluster_master_username
}

data "aws_ssm_parameter" "rds_cluster_master_password" {
  name = local.ssm_path.rds_cluster_master_password
}

locals {
  ssm_path = {
    rds_cluster_master_username = data.terraform_remote_state.ssm.outputs.parameter["rds_cluster_master_username"]["name"],
    rds_cluster_master_password = data.terraform_remote_state.ssm.outputs.parameter["rds_cluster_master_password"]["name"]
  }
  ssm_value = {
    rds_cluster_master_username = data.aws_ssm_parameter.rds_cluster_master_username.value,
    rds_cluster_master_password = data.aws_ssm_parameter.rds_cluster_master_password.value
  }
}
