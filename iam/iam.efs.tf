# AWS Backups IAM role for EFS Data Volume
resource "aws_iam_role" "efs_backup_role" {
  name               = "${local.name}-efs-backup-iam"
  assume_role_policy = templatefile("${path.module}/templates/iam/backup_assume_role.tpl", {})
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name}-efs-backup-iam"
    },
  )
}

resource "aws_iam_role_policy_attachment" "efs_backup_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.efs_backup_role.name
}

# AWS Restore Backups IAM role for EFS Data Volume
resource "aws_iam_role" "efs_restore_role" {
  name               = "${local.name}-efs-restore-iam"
  assume_role_policy = templatefile("${path.module}/templates/iam/backup_assume_role.tpl", {})
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name}-efs-restore-iam"
    },
  )
}

## The "AWSBackupServiceRolePolicyForBackup" AWS managed policy is missing a few KMS actions - after testing we learned that
## we need to copy that policy and modify it.
## Looks like the AWS managed policy has an issue as it is missing a simple "*" on
## "kms:GenerateDataKey"
## works with
## "kms:GenerateDataKey*"
resource "aws_iam_role_policy" "efs_restore_policy" {
  name = "${local.name}-efs-restore-iam"
  role = aws_iam_role.efs_restore_role.name

  policy = templatefile("${path.module}/templates/iam/MOJ_AWSBackupServiceRolePolicyForBackup.tpl", {})
}
