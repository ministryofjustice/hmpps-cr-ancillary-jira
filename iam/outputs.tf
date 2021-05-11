output "efs" {
  value = {
    backup_role = {
      name = aws_iam_role.efs_backup_role.name
      id   = aws_iam_role.efs_backup_role.id
      arn  = aws_iam_role.efs_backup_role.arn
    },
    restore_role = {
      name = aws_iam_role.efs_restore_role.name
      id   = aws_iam_role.efs_restore_role.id
      arn  = aws_iam_role.efs_restore_role.arn
    }
  }
}
