data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

data "aws_caller_identity" "current" {
}

#
locals {
  name = var.environment_name
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
