//Now we create the Agent which will act as the intermidiary between clients and the knowledge base
//For now we will not fine tune it for our candidate ranking. We will use an FM.
resource "aws_bedrockagent_agent" "aurora" {
  agent_name                  = "aurora-agent"
  agent_resource_role_arn     = aws_iam_role.example.arn
  idle_session_ttl_in_seconds = 500
  foundation_model            = var.fm_model_name
}

resource "aws_bedrockagent_agent_knowledge_base_association" "aurora" {
  agent_id             = aws_bedrockagent_agent.aurora.agent_id
  description          = "Aurora Candidate Search"
  knowledge_base_id    = aws_bedrockagent_knowledge_base.aurora.id
  knowledge_base_state = "ENABLED"
}
