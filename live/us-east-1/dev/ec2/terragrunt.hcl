skip = true

terraform {
  source = "tfr:///terraform-aws-modules/ec2-instance/aws//?version=5.6.1"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  region        = include.root.locals.region_vars.locals.aws_region
  environment   = include.root.locals.environment_vars.locals.environment
  instance_type = "t2.micro"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "security_group" {
  config_path = "../security_group"
}

inputs = {
  name          = "web-server-${local.environment}-${local.region}"
  instance_type = local.instance_type
  # key_name          = "my-key"
  subnet_id          = dependency.vpc.outputs.public_subnets[0]
  security_group_ids = [dependency.security_group.outputs.security_group_id]
  # user_data         = file("${path.module}/user-data.sh")

  tags = {
    Environment = local.region
  }
}