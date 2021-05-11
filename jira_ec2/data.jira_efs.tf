data "terraform_remote_state" "jira_efs" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "jira_efs/terraform.tfstate"
    region = var.region
  }
}
locals {
  efs_mount_target = data.terraform_remote_state.jira_efs.outputs.efs_mount_target
  efs              = data.terraform_remote_state.jira_efs.outputs.efs
  backup           = data.terraform_remote_state.jira_efs.outputs.backup
}
