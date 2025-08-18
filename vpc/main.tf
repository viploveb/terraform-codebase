provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}


################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 6.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 2)]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  manage_default_security_group = false

  tags = local.tags
}

resource "aws_security_group" "default" {
  name        = "${local.name}_default"
  description = "Default security group for mini_idp vpc"
  vpc_id      = module.vpc.vpc_id
  tags = {
    name = "${local.name}_default"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.default.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
