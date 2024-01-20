resource "aws_s3_bucket" "boilerplate_app" {
  bucket        = "${local.prefix}-bucket"
  force_destroy = true

  tags = local.common_tags
}

resource "aws_s3_bucket_acl" "boilerplate_app" {
  bucket = aws_s3_bucket.boilerplate_app.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "boilerplate_app" {
  bucket = aws_s3_bucket.boilerplate_app.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "boilerplate_app" {
  bucket = aws_s3_bucket.boilerplate_app.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "boilerplate_app" {
  bucket = aws_s3_bucket.boilerplate_app.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "boilerplate_app" {
  bucket = aws_s3_bucket.boilerplate_app.id
  policy = data.aws_iam_policy_document.boilerplate_app.json
}

data "aws_iam_policy_document" "boilerplate_app" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.boilerplate_app.arn,
      "${aws_s3_bucket.boilerplate_app.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.boilerplate_app.iam_arn]
    }
  }
}
