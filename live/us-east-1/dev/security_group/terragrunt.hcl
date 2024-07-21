skip = true

terraform {
  source = "tfr:///terraform-aws-modules/security-group/aws//modules/http-80//?version=5.1.2"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}