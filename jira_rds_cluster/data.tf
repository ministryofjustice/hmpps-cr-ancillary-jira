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
  name = var.environment_name
  allowed_security_groups = [
    data.terraform_remote_state.security-groups.outputs.id["egress_to_rds_cluster"]
  ]
  db_subnet_ids = [
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az1"]["id"]["db"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az2"]["id"]["db"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az3"]["id"]["db"],
  ]
  private_subnets_cidr_blocks = [
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az1"]["cidr"]["private"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az2"]["cidr"]["private"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az3"]["cidr"]["private"],
  ]
}
