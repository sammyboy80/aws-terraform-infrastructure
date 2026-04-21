# S3 bucket for static assets
resource "aws_s3_bucket" "assets" {
  bucket = "${var.project_name}-assets-sam-48291"

  tags = {
    Name      = "${var.project_name}-assets"
    ManagedBy = "terraform"
  }
}

# Block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
