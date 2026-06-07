resource "aws_s3_bucket" "static_bucket" {
  bucket = "terraform-static-content-bucket-123456789"

  tags = {
    Name = "static-content"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.static_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
