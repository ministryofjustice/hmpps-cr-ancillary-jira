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

variable "tiny_environment_identifier" {
  type = string
}


variable "aws_account_ids" {
  type = map(string)
}

variable "cr_account_ids" {
  type = map(string)
}

variable "aws_engineering_account_ids" {
  type = map(string)
}
