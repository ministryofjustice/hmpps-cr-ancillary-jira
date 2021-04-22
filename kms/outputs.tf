output "key" {
  value = {
    alias = aws_kms_alias.jira_key_alias.name,
    arn   = aws_kms_key.jira_key.arn,
    id    = aws_kms_key.jira_key.key_id
  }
}
