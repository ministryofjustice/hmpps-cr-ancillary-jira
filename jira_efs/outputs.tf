# jira efs
output "efs" {
  value = aws_efs_file_system.jira_efs
}

output "efs_route53" {
  value = aws_route53_record.jira_efs_private_dns
}

output "efs_mount_target" {
  value = {
    dns_name        = aws_efs_mount_target.jira_efs_mount[0].dns_name
    file_system_arn = aws_efs_mount_target.jira_efs_mount[0].file_system_arn
    file_system_id  = aws_efs_mount_target.jira_efs_mount[0].file_system_id
    // plurals
    ids                    = [aws_efs_mount_target.jira_efs_mount[*].id]
    mount_target_dns_names = [aws_efs_mount_target.jira_efs_mount[*].mount_target_dns_name]
    network_interface_ids  = [aws_efs_mount_target.jira_efs_mount[*].network_interface_id]
  }
}

output "backup" {
  value = {
    vault = {
      id              = aws_backup_vault.jira_efs_backup_vault.id
      arn             = aws_backup_vault.jira_efs_backup_vault.arn
      name            = aws_backup_vault.jira_efs_backup_vault.name
      recovery_points = aws_backup_vault.jira_efs_backup_vault.recovery_points
      kms_key_arn     = aws_backup_vault.jira_efs_backup_vault.kms_key_arn
    },
    plan = {
      id      = aws_backup_plan.jira_efs_backup_plan.id
      arn     = aws_backup_plan.jira_efs_backup_plan.arn
      name    = aws_backup_plan.jira_efs_backup_plan.name
      version = aws_backup_plan.jira_efs_backup_plan.version
      rule    = aws_backup_plan.jira_efs_backup_plan.rule
    },
    selection = {
      id           = aws_backup_selection.jira_efs_backup_selection.id
      name         = aws_backup_selection.jira_efs_backup_selection.name
      iam_role_arn = aws_backup_selection.jira_efs_backup_selection.iam_role_arn
      plan_id      = aws_backup_selection.jira_efs_backup_selection.plan_id
    }
  }
}
