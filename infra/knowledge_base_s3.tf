resource "aws_s3_bucket" "aurora_talent_search" {
  bucket = "aurora-talent-search"
}

resource "aws_s3_bucket_public_access_block" "aurora_talent_search_block" {
  bucket = aws_s3_bucket.aurora_talent_search.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM Policy to allow AWS Bedrock to access the S3 bucket
resource "aws_s3_bucket_policy" "aurora_talent_search_policy" {
  bucket = aws_s3_bucket.aurora_talent_search.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "bedrock.amazonaws.com"
            },
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:${data.aws_partition.current.partition}:s3:::aurora-talent-search",
                "arn:${data.aws_partition.current.partition}:s3:::aurora-talent-search/*"
            ]
        }
    ]
}
POLICY
}

output "s3_bucket_name" {
  value = aws_s3_bucket.aurora_talent_search.id
}
