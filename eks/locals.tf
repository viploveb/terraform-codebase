locals {
  name               = "mini_idp"
  region             = "us-east-1"
  kubernetes_version = "1.33"
  instance_types     = ["t4g.nano", "t3.nano"]
}