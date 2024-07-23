terraform {
  source = find_in_parent_folders("modules/ec2")
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
  config_path = "../vpc"
  mock_outputs = {
    public_subnets = ["subnet-12345678"]
  }
}

dependency "security_group_http" {
  config_path = "../security_group/http"
  mock_outputs = {
    security_group_id = "sg-12345678"
  }
}

dependency "security_group_ssh" {
  config_path = "../security_group/ssh"
  mock_outputs = {
    security_group_id = "sg-12345678"
  }
}

inputs = {
  instance_type = "t2.small"

  environment   = local.environment
  public_subnet = dependency.vpc.outputs.public_subnets[0]
  vpc_security_group_ids = [
    dependency.security_group_http.outputs.security_group_id,
    dependency.security_group_ssh.outputs.security_group_id,
  ]
}