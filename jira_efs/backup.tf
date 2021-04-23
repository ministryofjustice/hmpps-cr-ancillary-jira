## Module

resource "aws_backup_vault" "jira_efs_backup_vault" {
  name        = "${local.name}-efs-backup-pri-vlt"
  kms_key_arn = local.kms_key_arn
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name}-efs-backup-pri-vlt"
    },
  )
}

resource "aws_backup_plan" "jira_efs_backup_plan" {
  name = "${local.name}-efs-bkup-pri-pln"

  rule {
    rule_name         = "JIRA_EFS_Volume_Backup"
    target_vault_name = aws_backup_vault.jira_efs_backup_vault.name
    schedule          = var.efs_conf["backup_cron"]

    lifecycle {
      cold_storage_after = var.efs_conf["backup_coldstorage_after_days"]
      delete_after       = var.efs_conf["backup_delete_after_days"]
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = "${local.name}-jirabkup-pri-pln"
    },
  )
}

resource "aws_backup_selection" "jira_efs_backup_selection" {
  iam_role_arn = local.efs_backup_role_arn
  name         = "${local.name}-jiraabkup-pri-sel"
  plan_id      = aws_backup_plan.jira_efs_backup_plan.id

  resources = [
    aws_efs_file_system.jira_efs.arn,
  ]
}
