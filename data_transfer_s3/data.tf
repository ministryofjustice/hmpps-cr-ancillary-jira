data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "template_file" "s3_data_bucket_policy" {
  template = file("policies/s3_data_bucket_policy.json")

  vars = {
    s3_bucket_arn              = aws_s3_bucket.data.arn
    hmpps-engineering-prod     = var.aws_engineering_account_ids["prod"]
    hmpps-engineering-non-prod = var.aws_engineering_account_ids["non-prod"]
    hmpps-probation            = var.aws_account_ids["hmpps-probation"]
    hmpps-cr-jira-production   = var.cr_account_ids["hmpps-cr-jira-production"]
  }
}
