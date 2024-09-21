# S3 Bucket for uploads
resource "aws_s3_bucket" "resumes_bucket" {
  bucket = "aurora-resumes-s123"
}

# IAM Role for API Gateway to interact with S3
resource "aws_iam_role" "api_gw_s3_role" {
  name = "api-gateway-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "apigateway.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "api_gw_s3_policy" {
  role = aws_iam_role.api_gw_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      Resource = "${aws_s3_bucket.resumes_bucket.arn}/*"
    }]
  })
}

resource "aws_api_gateway_rest_api" "app" {
  name        = "s3-upload-api"
  description = "API to generate S3 pre-signed URLs"
}

resource "aws_api_gateway_resource" "resumes" {
  parent_id   = aws_api_gateway_rest_api.app.root_resource_id
  path_part   = "resumes"
  rest_api_id = aws_api_gateway_rest_api.app.id
}

resource "aws_api_gateway_method" "resumes_post_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.resumes.id
  rest_api_id   = aws_api_gateway_rest_api.app.id
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.app.id
  resource_id             = aws_api_gateway_resource.resumes.id
  http_method             = aws_api_gateway_method.resumes_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.resumes.invoke_arn
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

resource "aws_lambda_function" "resumes" {
  filename      = "lambda.zip"
  function_name = "resume-api"
  role          = aws_iam_role.role.arn
  handler       = "resume_api.app.lambda_handler"
  runtime       = "python3.11"

  source_code_hash = filebase64sha256("resumes-api.zip")

  environment {
    variables = {
      RESUME_S3_BUCKET_NAME = "${aws_s3_bucket.resumes_bucket.id}"
    }
  }
}

# IAM
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "myrole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Deploy API Gateway
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.post_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.app.id
  stage_name  = "prod"
}

# Output the API endpoint
output "api_endpoint" {
  value = "${aws_api_gateway_rest_api.app.execution_arn}/resumes"
}
