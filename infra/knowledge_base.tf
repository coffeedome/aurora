
resource "aws_opensearchserverless_security_policy" "aurora" {
  name = "aurora"
  type = "encryption"
  policy = jsonencode({
    "Rules" = [
      {
        "Resource" = [
          "collection/aurora"
        ],
        "ResourceType" = "collection"
      }
    ],
    "AWSOwnedKey" = true
  })
}

resource "aws_opensearchserverless_collection" "aurora" {
  name = "aurora"

  depends_on = [aws_opensearchserverless_security_policy.aurora]
}

//Creates the knowledge base and we tell it to use OS for vector storage
resource "aws_bedrockagent_knowledge_base" "aurora" {
  name     = "aurora"
  role_arn = aws_iam_role.bedrock_service_role.arn
  knowledge_base_configuration {
    vector_knowledge_base_configuration {
      embedding_model_arn = "arn:${data.aws_partition.current.partition}:bedrock:us-west-2::foundation-model/amazon.titan-embed-text-v1"
    }
    type = "VECTOR"
  }
  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration {
      collection_arn    = aws_opensearchserverless_collection.aurora.arn
      vector_index_name = "aurora-bedrock-knowledge-base-default-index"
      field_mapping {
        vector_field   = "aurora-bedrock-knowledge-base-default-vector"
        text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }
  }
}

// We add data source to knowledge base: S3 bucket containing our PDFs
resource "aws_bedrockagent_data_source" "aurora_resumes" {
  knowledge_base_id    = aws_bedrockagent_knowledge_base.aurora.id
  name                 = "aurora-s3-resumes"
  data_deletion_policy = "DELETE" //switch to RETAIN for keeping vectors of data source. Does not delete vector store (OS)
  data_source_configuration {
    type = "S3"
    s3_configuration {
      bucket_arn = aws_s3_bucket.aurora_talent_search.arn
    }
  }
}
