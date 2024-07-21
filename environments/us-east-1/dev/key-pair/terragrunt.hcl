terraform {
  source = "tfr:///terraform-aws-modules/key-pair/aws//?version=2.0.3"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  region      = include.root.locals.region_vars.locals.aws_region
  environment = include.root.locals.environment_vars.locals.environment
}

inputs = {
  key_name   = "${local.environment}-key-pair"
  public_key = get_env("TF_VAR_key", "")
}