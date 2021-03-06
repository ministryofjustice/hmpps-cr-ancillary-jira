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
  name   = var.environment_name
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = [
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az1"]["id"]["private"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az2"]["id"]["private"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az3"]["id"]["private"],
  ]
  jira_ecs_security_groups = [
    data.terraform_remote_state.security-groups.outputs.id["ingress_to_jira"],
    data.terraform_remote_state.security-groups.outputs.id["egress_from_jira"]
  ]
}
