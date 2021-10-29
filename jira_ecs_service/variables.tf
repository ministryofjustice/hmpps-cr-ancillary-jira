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

variable "jira_ecs_conf" {
  description = "Config map for Jira Service ECS task"
  type        = map(string)

  default = {
    image         = "docker.io/atlassian/jira-servicemanagement"
    image_version = "4.17.0"
    service_port  = "8080"
    cpu           = "1024"
    memory        = "4096"

    ehcache_listener_port = "40001" # (default: 40001)

    # ECS Task App Autoscaling min and max thresholds
    ecs_scaling_min_capacity = 1
    ecs_scaling_max_capacity = 5

    # ECS Task App AutoScaling will kick in above avg cpu util set here
    ecs_target_cpu = "60"

    clustered = true
  }
}

variable "jira_conf" {
  description = "Config map for Jira configuration"
  type        = map(string)

  default = {
    ## Jira (default: 1209600; two weeks, in seconds)
    ## The maximum time a user can remain logged-in with 'Remember Me'.
    ## Override to 1 working day of 8 hours (60 seconds * 60 minutes * 8 hours = 28800)
    login_duration             = "28800"
    jira_db_driver             = "org.postgresql.Driver"
    jira_db_type               = "postgresaurora96"
    efs_jira_base_dir          = "/var/jira"
    src_jira_home              = "/var/jira/jira_home"
    src_jira_home_node1        = "/var/jira/jira_home_node1"
    src_jira_home_node2        = "/var/jira/jira_home_node2"
    src_jira_home_node3        = "/var/jira/jira_home_node3"
    src_shared_home            = "/var/jira/jira_shared_home"
    container_jira_home        = "/var/atlassian/application-data/jira"
    container_jira_shared_home = "/var/atlassian/application-data/shared"
  }
}

variable "cloudwatch_log_retention" {
  description = "Cloudwatch logs data retention in days"
  default     = "14"
}
