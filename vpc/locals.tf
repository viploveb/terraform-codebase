locals {
  name   = "ex"
  region = "us-east-1"

  vpc_cidr = "192.168.0.0/24"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc"
    GithubOrg  = "terraform-aws-modules"
  }
}