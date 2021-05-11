variable "environment_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "region" {
  description = "The AWS region."
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_identifier" {
  description = "resource label or name"
}

variable "efs_conf" {
  description = "JIRA Data EFS Volume Config"
  type        = map(string)

  default = {
    encrypted                       = true
    performance_mode                = "generalPurpose"
    provisioned_throughput_in_mibps = 0
    throughput_mode                 = "bursting"
    backup_cron                     = "cron(0 02 * * ? *)"
    backup_coldstorage_after_days   = 30
    # delet must be >= 90days from cold storage move
    backup_delete_after_days = 120
    # set this when doing a restore to the creation token
    creation_token = ""
  }
}
