resource "aws_s3_bucket" "boilerplate_s3_bucket" {
  bucket        = "${local.prefix}-bucket"
  force_destroy = true

  tags = local.common_tags
}

resource "aws_s3_bucket_acl" "boilerplate_s3_bucket_acl" {
  bucket = aws_s3_bucket.boilerplate_s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.boilerplate_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "boilerplate_s3_bucket_versioning" {
  bucket = aws_s3_bucket.boilerplate_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
