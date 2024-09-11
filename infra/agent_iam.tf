data "aws_iam_policy_document" "aurora_agent_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["bedrock.amazonaws.com"]
      type        = "Service"
    }
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }
    condition {
      test     = "ArnLike"
      values   = ["arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:agent/*"]
      variable = "AWS:SourceArn"
    }
  }
}

data "aws_iam_policy_document" "aurora_agent_permissions" {
  statement {
    actions = ["bedrock:InvokeModel"]
    resources = [
      "arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}::foundation-model/${var.fm_model_name}",
    ]
  }
}

resource "aws_iam_role" "aurora_agent_role" {
  assume_role_policy = data.aws_iam_policy_document.aurora_agent_trust.json
  name_prefix        = "AmazonBedrockExecutionRoleForAgents_"
}

resource "aws_iam_role_policy" "aurora_agent_role_policy" {
  policy = data.aws_iam_policy_document.aurora_agent_permissions
  role   = aws_iam_role.aurora_agent_role.id
}

resource "aws_bedrockagent_agent" "aurora" {
  agent_name                  = "aurora-candidate-finder"
  agent_resource_role_arn     = aws_iam_role.aurora_agent_role.arn
  idle_session_ttl_in_seconds = 500
  foundation_model            = var.fm_model_name
}
