#Bedrock service role for giving it access to OpenSearch and Knowledge Bases
data "aws_iam_policy_document" "bedrock_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        "account-id"
      ]
    }

    condition {
      test     = "ArnLike"
      variable = "AWS:SourceArn"

      values = [
        "arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}:account-id:knowledge-base/*"
      ]
    }
  }
}

resource "aws_iam_role" "bedrock_service_role" {
  name               = "aurora_app_bedrock_knowledge_bases_service_role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.bedrock_assume_role_policy.json
}

#Permissions to access Amazon Bedrock models
resource "aws_iam_role_policy" "bedrock_model_access" {
  name = "aurora_bedrock_model_access"
  role = aws_iam_role.bedrock_service_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "bedrock:ListFoundationModels",
          "bedrock:ListCustomModels"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "bedrock:InvokeModel"
        ],
        "Resource" : [
          "arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}::foundation-model/${var.fm_model_name}",
        ]
      }
    ]
  })
}

#Permissions to chat with document
resource "aws_iam_role_policy" "bedrock_chat_with_doc" {
  name = "aurora_bedrock_chat_with_doc"
  role = aws_iam_role.bedrock_service_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "bedrock:RetrieveAndGenerate"
        ],
        "Resource" : "*"
      }
    ]
  })
}


