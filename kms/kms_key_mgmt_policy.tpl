{
    "Version": "2012-10-17",
    "Id": "JIRA Key Management Policy",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${aws_account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${aws_account_id}:role/terraform"
                ]
            },
            "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion",
                "kms:GenerateDataKey"
            ],
            "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "logs.${region}.amazonaws.com"
          },
          "Action": [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*"
          ],
          "Resource": "arn:aws:kms:${region}:${aws_account_id}:key/*",
          "Condition": {
            "ArnLike": {
              "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:${region}:${aws_account_id}:log-group:*"
            }
          }
        }
    ]
}
