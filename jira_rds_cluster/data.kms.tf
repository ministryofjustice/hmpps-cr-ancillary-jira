data "terraform_remote_state" "kms" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "kms/terraform.tfstate"
    region = var.region
  }
}

locals {
  jira_kms_key_arn = data.terraform_remote_state.kms.outputs.key["arn"]
}
