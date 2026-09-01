data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "docs" {
  bucket = "agentic-rag-aws-docs-${data.aws_caller_identity.current.account_id}"
}