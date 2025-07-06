resource "aws_s3_bucket" "app_uploads" {
  bucket        = var.bucket_name
  force_destroy = true
  tags = {
    Name = "ror-app-uploads"
  }
}