terraform {
  source = find_in_parent_folders("modules/security_group/ssh")
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  environment = include.root.locals.environment_vars.locals.environment
  region      = include.root.locals.region_vars.locals.region
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    vpc_id = "vpc-12345678"
  }
}

inputs = {
  region      = local.region
  environment = local.environment

  vpc_id = dependency.vpc.outputs.vpc_id
}