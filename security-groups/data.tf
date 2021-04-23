data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

locals {
  name = var.environment_name
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
//  db_subnet_ids = [
//    data.terraform_remote_state.vpc.outputs.vpc_subnet["az1"]["id"]["db"],
//    data.terraform_remote_state.vpc.outputs.vpc_subnet["az2"]["id"]["db"],
//    data.terraform_remote_state.vpc.outputs.vpc_subnet["az3"]["id"]["db"],
//  ]
//  private_subnets_cidr_blocks = [
//    data.terraform_remote_state.vpc.outputs.vpc_subnet["az1"]["cidr"]["private"],
//    data.terraform_remote_state.vpc.outputs.vpc_subnet["az2"]["cidr"]["private"],
//    data.terraform_remote_state.vpc.outputs.vpc_subnet["az3"]["cidr"]["private"],
//  ]
//  public_subnets_cidr_blocks = [
//    data.terraform_remote_state.vpc.outputs.vpc_subnet["az1"]["cidr"]["public"],
//    data.terraform_remote_state.vpc.outputs.vpc_subnet["az2"]["cidr"]["public"],
//    data.terraform_remote_state.vpc.outputs.vpc_subnet["az3"]["cidr"]["public"],
//  ]
}
