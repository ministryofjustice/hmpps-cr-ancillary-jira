variable "environment_name" {
  type = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "jira_conf" {
  description = "JIRA Server Config"
  type        = map(string)
}

variable "jira_db_cloudwatch_log_exports" {
  description = "List of enabled logs to export to Cloudwatch Logs"
  type        = list(string)

  default = [
    "error",
  ]
}

variable "jira_data" {
  description = "List of data parameters"
  type        = map(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet ids"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet ids"
  type        = list(string)
}

variable "alb_security_groups" {
  description = "List of security group ids for the public facing ALB"
  type        = list(string)
}

variable "asg_security_groups" {
  description = "List of security group ids for the private ASG"
  type        = list(string)
}
