resource "aws_kms_key" "jira_key" {
  description             = "JIRA Encryption Key"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  policy                  = templatefile("${path.module}/kms_key_mgmt_policy.tpl", { aws_account_id = data.aws_caller_identity.current.account_id })
  tags = merge(
    var.tags,
    {
      "Name" = "${var.environment_name}-jira-pri-kms"
    },
  )
}

resource "aws_kms_alias" "jira_key_alias" {
  name          = "alias/jira-kms-key"
  target_key_id = aws_kms_key.jira_key.key_id
}
