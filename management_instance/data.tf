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

data "terraform_remote_state" "security-groups" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "security-groups/terraform.tfstate"
    region = var.region
  }
}

data "aws_ami" "latest_ecs" {
  most_recent = true
  owners      = ["591542846629"] # AWS

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*"]
  }

//  filter {
//    name = "description"
//    values = ["Amazon Linux AMI 2.0 *"]
//  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

#
locals {
  name          = var.environment_name
  instance_name = "${var.environment_name}-management"
  ami_id        = data.aws_ami.latest_ecs.id

  jira_ecs_security_groups = [
    data.terraform_remote_state.security-groups.outputs.id["ingress_to_jira"],
    data.terraform_remote_state.security-groups.outputs.id["egress_from_jira"]
  ]

  private_subnet_ids = [
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az1"]["id"]["private"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az2"]["id"]["private"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az3"]["id"]["private"],
  ]

}
