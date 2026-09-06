data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "docs" {
  bucket = "agentic-rag-aws-docs-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_public_access_block" "docs" {
  bucket = aws_s3_bucket.docs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "docs" {
  bucket = aws_s3_bucket.docs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "docs" {
  bucket = aws_s3_bucket.docs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "docs" {
  for_each = fileset("${path.module}/../sample_docs", "*.docx")

  bucket = aws_s3_bucket.docs.id
  key    = each.value
  source = "${path.module}/../sample_docs/${each.value}"
  etag   = filemd5("${path.module}/../sample_docs/${each.value}")
}