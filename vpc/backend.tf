terraform {
  backend "s3" {
    bucket       = "terraform-state-a2ce967778492fbe"
    key          = "vpc/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
