data "aws_iam_policy_document" "s3_upload_lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_role_s3_upload_lambda" {
  name               = "aurora_s3_upload_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.s3_upload_lambda_assume_role.json
}

resource "aws_lambda_function" "s3_upload_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "aurora_s3_upload_service"
  role          = aws_iam_role.iam_role_s3_upload_lambda.arn
  handler       = "index.test"
  runtime       = "nodejs18.x"

  ephemeral_storage {
    size = 10240 # Min 512 MB and the Max 10240 MB
  }
}

resource "aws_lambda_function_url" "s3_uploads" {
  function_name      = aws_lambda_function.s3_upload_lambda.function_name
  qualifier          = "aurora_s3_upload"
  authorization_type = "AWS_IAM"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}
