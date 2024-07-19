terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws//?version=5.8.1"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  name        = include.root.locals.name
  region      = include.root.locals.region
  environment = include.root.locals.environment
}

inputs = {
  name = "${local.name}-${local.environment}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  tags = {
    IAC         = "true"
    Environment = local.environment
    region      = local.region
    project     = local.name
  }
}