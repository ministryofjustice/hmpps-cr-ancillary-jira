data "terraform_remote_state" "kms" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "kms/terraform.tfstate"
    region = var.region
  }
}

locals {
  kms_key_arn = data.terraform_remote_state.kms.outputs.key["arn"]
  kms_key_id  = data.terraform_remote_state.kms.outputs.key["id"]
}
