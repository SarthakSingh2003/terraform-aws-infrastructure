# S3 Bucket for Frontend
resource "aws_s3_bucket" "frontend" {
  bucket = var.bucket_name

  tags = merge(
    var.common_tags,
    {
      Name = var.bucket_name
    }
  )
}

# S3 Website Configuration
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# S3 Bucket Public Access Block (Must allow public for website)
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Policy (Read only for public)
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.frontend.json

  depends_on = [aws_s3_bucket_public_access_block.frontend]
}

data "aws_iam_policy_document" "frontend" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.frontend.arn}/*",
    ]
  }
}

# Dummy Index File
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "index.html"
  content      = "<html><h1>Hello from Terraform Dummy Frontend</h1></html>"
  content_type = "text/html"
}
