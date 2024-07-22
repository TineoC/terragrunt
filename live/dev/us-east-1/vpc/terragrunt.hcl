terraform {
  source = find_in_parent_folders("modules/vpc")
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  environment = include.root.locals.environment_vars.locals.environment
  region      = include.root.locals.region_vars.locals.region
}

inputs = {
  region      = local.region
  environment = local.environment
}