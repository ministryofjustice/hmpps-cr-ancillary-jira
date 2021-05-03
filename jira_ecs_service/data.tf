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

data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "ecs_cluster/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "jira_efs" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "jira_efs/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "jira_rds_cluster" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "jira_rds_cluster/terraform.tfstate"
    region = var.region
  }
}
#
locals {
  name              = var.environment_name
  jira_service_name = "${local.name}-jira-service"
  app_name          = "jira"
  dns_name          = "service"
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  namespace_id      = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster_private_namespace["id"]
  alb_security_groups = [
    data.terraform_remote_state.security-groups.outputs.id["ingress_to_jira_lb"],
    data.terraform_remote_state.security-groups.outputs.id["egress_from_jira_lb"]
  ]
  jira_ecs_security_groups = [
    data.terraform_remote_state.security-groups.outputs.id["ingress_to_jira"],
    data.terraform_remote_state.security-groups.outputs.id["egress_from_jira"]
  ]
  public_subnet_ids = [
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az1"]["id"]["public"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az2"]["id"]["public"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az3"]["id"]["public"],
  ]
  private_subnet_ids = [
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az1"]["id"]["private"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az2"]["id"]["private"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az3"]["id"]["private"],
  ]
  internal_zone_id   = data.terraform_remote_state.vpc.outputs.zone["private"]["id"]
  internal_zone_name = data.terraform_remote_state.vpc.outputs.zone["private"]["name"]
  public_zone_id     = data.terraform_remote_state.vpc.outputs.zone["public"]["id"]
  public_zone_name   = data.terraform_remote_state.vpc.outputs.zone["public"]["name"]
  jira_db_endpoint   = data.terraform_remote_state.jira_rds_cluster.outputs.rds_cluster["endpoint"]
  efs                = data.terraform_remote_state.jira_efs.outputs.efs
}

//id = {
//  "egress_from_jira" = "sg-06651049c4d7c22ae"
//  "egress_from_jira_lb" = "sg-07abe79cdf65a5dfb"
//  "egress_to_rds_cluster" = "sg-08b2b85ddbc9efc41"
//  "ingress_to_efs" = "sg-036e5b5233f9945e6"
//  "ingress_to_jira" = "sg-09954e1f795decd87"
//  "ingress_to_jira_lb" = "sg-0ea726f6f7fec9d2d"
//}
