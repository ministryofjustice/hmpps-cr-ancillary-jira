## Module

resource "aws_efs_file_system" "jira_efs" {
  creation_token                  = var.efs_conf["creation_token"] == "" ? local.jira_efs_name : var.efs_conf["creation_token"]
  kms_key_id                      = local.kms_key_arn
  encrypted                       = var.efs_conf["encrypted"]
  performance_mode                = var.efs_conf["performance_mode"]
  provisioned_throughput_in_mibps = var.efs_conf["provisioned_throughput_in_mibps"]
  throughput_mode                 = var.efs_conf["throughput_mode"]

  tags = merge(
    var.tags,
    {
      "Name" = local.jira_efs_name
    },
  )
}

resource "aws_efs_mount_target" "jira_efs_mount" {
  count           = length(local.db_subnet_ids)
  file_system_id  = aws_efs_file_system.jira_efs.id
  subnet_id       = element(compact(local.db_subnet_ids), count.index)
  security_groups = local.efs_security_groups
}
