resource "aws_s3_bucket" "b" {
  bucket        = "${local.prefix}-bucket"
  force_destroy = true

  tags = local.common_tags
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket     = aws_s3_bucket.b.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.b_ownership_controls]
}

resource "aws_s3_bucket_ownership_controls" "b_ownership_controls" {
  bucket = aws_s3_bucket.b.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "b_public_access_block" {
  bucket = aws_s3_bucket.b.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "b_versioning" {
  bucket = aws_s3_bucket.b.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "b_website_configuration" {
  bucket = aws_s3_bucket.b.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "b_policy" {
  bucket = aws_s3_bucket.b.id
  policy = data.aws_iam_policy_document.b_document.json
}

data "aws_iam_policy_document" "b_document" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.b.arn,
      "${aws_s3_bucket.b.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cf_origin_access_identity.iam_arn]
    }
  }
}
