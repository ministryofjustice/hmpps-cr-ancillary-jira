data "aws_caller_identity" "current" {
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "security-groups" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "security-groups/terraform.tfstate"
    region = var.region
  }
}
#
locals {
  name          = var.environment_name
  jira_efs_name = "${local.name}-jira-efs"
  efs_security_groups = [
    data.terraform_remote_state.security-groups.outputs.id["ingress_to_efs"]
  ]
  db_subnet_ids = [
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az1"]["id"]["db"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az2"]["id"]["db"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az3"]["id"]["db"],
  ]
  internal_zone_id   = data.terraform_remote_state.vpc.outputs.zone["private"]["id"]
  internal_zone_name = data.terraform_remote_state.vpc.outputs.zone["private"]["name"]
}
