resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket
  tags   = var.tags
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = file(var.bucket_policy_path)
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_logging" "logging" {
  count  = var.create_logging ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  target_bucket = var.target_bucket
  target_prefix = var.target_prefix
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_master_key_id
      sse_algorithm     = var.sse_algorithm
    }
  }
}