include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../kms",
    "../ssm",
    "../jira_efs",
    "../jira_rds_cluster",
    "../security-groups"
  ]
}
