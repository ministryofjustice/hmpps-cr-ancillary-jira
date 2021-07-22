#-------------------------------------------------------------
### Getting the database (jira_rds_cluster) details
#-------------------------------------------------------------
data "terraform_remote_state" "jira_rds_cluster" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "jira_rds_cluster/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the Jira (jira_ec2) details
#-------------------------------------------------------------
data "terraform_remote_state" "jira_ec2" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "jira_ec2/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the Monitoring details
#-------------------------------------------------------------
data "terraform_remote_state" "monitoring" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "monitoring/terraform.tfstate"
    region = var.region
  }
}
