terraform {
  source = "tfr:///terraform-aws-modules/security-group/aws//modules/ssh//?version=5.1.2"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  region      = include.root.locals.region_vars.locals.aws_region
  environment = include.root.locals.environment_vars.locals.environment
}

dependency "vpc" {
  config_path = "../../vpc"

  mock_outputs = {
    vpc_id = "vpc-12345678"
  }
}

inputs = {
  name        = "ssh-access-${local.environment}-sg"
  description = "Security group for web-server with SSH ports open"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_cidr_blocks = ["148.255.245.25/32"]

  tags = {
    Environment = local.environment
  }
}