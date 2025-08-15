provider "aws" {
  region = "us-east-1"
}

resource "random_id" "this" {
  byte_length = 8
}

resource "aws_s3_bucket" "terraform_backend_bucket" {
  bucket = "terraform-state-${random_id.this.hex}"
  region = "us-east-1"
  tags = {
    Name = "terraform state"
  }
}

resource "aws_s3_bucket_versioning" "terraform_backend_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_backend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_backend_bucket_encryption" {
  bucket = aws_s3_bucket.terraform_backend_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


output "bucket_id" {
  description = "terraform state s3 bucket id"
  value       = resource.aws_s3_bucket.terraform_backend_bucket.id
}