provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

data "aws_vpc" "this" {
  filter {
    name   = "tag:name"
    values = ["mini_idp"]
  }
}

data "aws_subnets" "this" {
  filter {
    name   = "tag:Name"
    values = ["mini_idp-private-*"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.name
  kubernetes_version = local.kubernetes_version

  # Optional
  endpoint_public_access = false

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    spot_nodes = {
      instance_types = local.instance_types
      min_size       = 1
      max_size       = 2
      desired_size   = 2
      capacity_type  = "SPOT"
      labels         = { role = "spot-worker" }
    }
  }

  vpc_id     = data.aws_vpc.this.id
  subnet_ids = data.aws_subnets.this.ids

  tags = {
    Name        = local.name
    Environment = "dev"
    Terraform   = "true"
  }
}