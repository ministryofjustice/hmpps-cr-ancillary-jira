variable "environment_name" {
  type = string
}

variable "environment_type" {
  type        = string
  description = "Environment type to be used as a unique identifier for resources - eg. dev or pre-prod"
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
