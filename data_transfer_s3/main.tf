resource "aws_s3_bucket" "data" {
  bucket = "${var.tiny_environment_identifier}-data"

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default {
        kms_master_key_id = local.kms_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = merge(var.tags, { "Name" = "${var.tiny_environment_identifier}-data" }, )
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket              = aws_s3_bucket.data.id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_policy" "data" {
  bucket = aws_s3_bucket.data.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "CRS3POLICY"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.data.arn,
          "${aws_s3_bucket.data.arn}/*",
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "8.8.8.8/32"
          }
        }
      },
    ]
  })
}
