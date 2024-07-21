terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws//?version=5.9.0"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  region      = include.root.locals.region_vars.locals.aws_region
  environment = include.root.locals.environment_vars.locals.environment
  cidr_block  = "10.0.0.0/16"
}

inputs = {
  name = "${local.environment}-vpc"

  cidr_block = local.cidr_block
  azs        = ["${local.region}a", "${local.region}b", "${local.region}c"]
  # private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # enable_nat_gateway      = true
  map_public_ip_on_launch = true

  tags = {
    Environment = local.environment
  }
}