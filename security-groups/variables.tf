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

variable "cr_ancillary_admin_cidrs" {
  type = list(string)
}

variable "cr_ancillary_access_cidrs" {
  type = list(string)
}

variable "cr_ancillary_route53_healthcheck_access_cidrs" {
  type = list(string)
}

variable "cr_ancillary_route53_healthcheck_access_ipv6_cidrs" {
  type = list(string)
}
