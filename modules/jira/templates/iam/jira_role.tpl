{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CloudWatchLogsPermissions",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Sid": "SSMParameterPermissions",
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "kms:Decrypt"
      ],
        "Resource": "*"
    },
    {
      "Sid": "S3ArtefactBucketPermissions",
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets",
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
          "arn:aws:s3:::tf-eu-west-2-hmpps-eng-dev-artefacts-s3bucket",
          "arn:aws:s3:::tf-eu-west-2-hmpps-eng-dev-artefacts-s3bucket/*",
          "arn:aws:s3:::tf-eu-west-2-hmpps-eng-prod-artefacts-s3bucket/JIRA",
          "arn:aws:s3:::tf-eu-west-2-hmpps-eng-prod-artefacts-s3bucket/JIRA/*"
      ]
    },
    {
      "Sid": "S3TempPermissions",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
      }
  ]
}
