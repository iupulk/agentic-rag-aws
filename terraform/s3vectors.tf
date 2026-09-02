resource "aws_s3vectors_vector_bucket" "main" {
  vector_bucket_name = "agentic-rag-aws-vectors"

  encryption_configuration {
    sse_type = "AES256"
  }
}

resource "aws_s3vectors_index" "chunks" {
  vector_bucket_name = aws_s3vectors_vector_bucket.main.vector_bucket_name
  index_name         = "chunks"

  data_type       = "float32"
  dimension       = 384
  distance_metric = "cosine"

  metadata_configuration {
    non_filterable_metadata_keys = ["text"]
  }
}