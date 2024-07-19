terraform {
  source = "tfr:///terraform-aws-modules/ec2-instance/aws//?version=5.6.1"
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

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name = "${local.name}-server"

  instance_type = "t2.micro"

  subnet_id = dependency.vpc.outputs.public_subnets[0]

  tags = {
    IAC         = "true"
    Environment = local.environment
  }
}