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
#
locals {
  name   = var.environment_name
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}
