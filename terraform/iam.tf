data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "index_fn" {
  name               = "agentic-rag-aws-index-fn"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role_policy_attachment" "index_fn_basic_logs" {
  role       = aws_iam_role.index_fn.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "index_fn" {
  statement {
    sid       = "ReadSourceDocs"
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = [aws_s3_bucket.docs.arn, "${aws_s3_bucket.docs.arn}/*"]
  }

  statement {
    sid       = "WriteVectorIndex"
    actions   = ["s3vectors:PutVectors", "s3vectors:GetIndex", "s3vectors:DeleteVectors", "s3vectors:ListVectors"]
    resources = [aws_s3vectors_vector_bucket.main.vector_bucket_arn, aws_s3vectors_index.chunks.index_arn]
  }
}

resource "aws_iam_role_policy" "index_fn" {
  name   = "agentic-rag-aws-index-fn"
  role   = aws_iam_role.index_fn.id
  policy = data.aws_iam_policy_document.index_fn.json
}