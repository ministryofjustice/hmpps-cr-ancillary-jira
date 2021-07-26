data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "iam/terraform.tfstate"
    region = var.region
  }
}

locals {
  rds_enhanced_monitoring_role_arn = data.terraform_remote_state.iam.outputs.rds["enhanced_monitoring_role"]["arn"]
}
