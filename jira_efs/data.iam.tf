data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "iam/terraform.tfstate"
    region = var.region
  }
}

locals {
  efs_backup_role_arn = data.terraform_remote_state.iam.outputs.efs["backup_role"]["arn"]
}
