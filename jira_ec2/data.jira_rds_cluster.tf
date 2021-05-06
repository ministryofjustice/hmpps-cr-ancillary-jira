data "terraform_remote_state" "jira_rds_cluster" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "jira_rds_cluster/terraform.tfstate"
    region = var.region
  }
}

locals {
  rds_cluster = data.terraform_remote_state.jira_rds_cluster.outputs.rds_cluster
}
