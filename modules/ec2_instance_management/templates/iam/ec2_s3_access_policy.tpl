{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CRJiraServiceManagementUploadsKMS",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt",
                "kms:GenerateDataKey"
            ],
            "Resource": [
                "${dev_bucket_kms_arn}",
                "${prod_bucket_kms_arn}"
            ]
        },
        {
            "Sid": "CRJiraServiceManagementUploadsListBuckets",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListAllMyBuckets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "CRJiraServiceManagementUploadsObjects",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "${dev_bucket_arn}",
                "${dev_bucket_arn}/*",
                "${prod_bucket_arn}",
                "${prod_bucket_arn}/*"
            ]
        }
    ]
}
