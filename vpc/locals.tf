locals {
  name   = "mini_idp"
  region = "us-east-1"

  vpc_cidr = "192.168.0.0/20"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    name = local.name
    env  = "dev"
  }
}