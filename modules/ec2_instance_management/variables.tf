variable "environment_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "region" {
  description = "The AWS region."
}

variable "ec2_conf" {
  description = "EC2 Instance Configuration"
  default = {
    app_name                    = ""
    ami_id                      = ""
    instance_type               = ""
    subnet_id                   = ""
    iam_instance_profile        = ""
    associate_public_ip_address = false
    security_groups             = []
    user_data                   = ""
    monitoring                  = true
    root_device_size            = 32 #min required
  }
}

variable "jira_conf" {
  description = "Jira Configuration"
  default = {
    jira_data_volume_id       = ""
    jira_data_dns_name        = ""
    jira_db_endpoint          = ""
    jira_cloudwatch_log_group = ""
  }
}
//# JIRA
//jira_user: ${jira_user}
//jira_group: ${jira_group}
//jira_smtp_user: ${jira_smtp_user}
//jira_smtp_endpoint: ${jira_smtp_endpoint}
//jira_smtp_port: ${jira_smtp_port}
//jira_smtp_starttls: ${jira_smtp_starttls}
//jira_version: ${jira_version}
//jira_filename: ${jira_filename}
//jira_db_name: ${jira_db_name}
//jira_db_endpoint: ${jira_db_endpoint}
//db_master_user: ${db_master_user}
//jira_data_volume_id: ${jira_data_volume_id}
//jira_external_endpoint: ${jira_external_endpoint}
//mysql_connector_version: ${mysql_connector_version}
