output "key" {
  value = {
    alias     = aws_kms_alias.jira_key_alias.name,
    alias_arn = aws_kms_alias.jira_key_alias.arn,
    arn       = aws_kms_key.jira_key.arn,
    id        = aws_kms_key.jira_key.key_id
  }
}
