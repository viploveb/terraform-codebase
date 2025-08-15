provider "aws" {
  region = "us-east-1"
}

resource "random_id" "this" {
  byte_length = 8
}

resource "aws_s3_bucket" "this" {
  bucket = "terraform-state-${random_id.this.hex}"
  region = "us-east-1"
  tags = {
    Name = "terraform state"
  }
}


output "bucket_id" {
  description = "terraform state s3 bucket id"
  value = resource.aws_s3_bucket.this.id
}