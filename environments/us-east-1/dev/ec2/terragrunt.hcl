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
  ami_id        = "ami-04a81a99f5ec58529"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    public_subnets = ["subnet-12345678"]
  }
}

dependency "security_group_web" {
  config_path = "../security_group/web"

  mock_outputs = {
    security_group_id = "sg-12345678"
  }
}

dependency "security_group_ssh" {
  config_path = "../security_group/ssh"

  mock_outputs = {
    security_group_id = "sg-12345679"
  }
}

inputs = {
  name          = "web-server-${local.environment}"
  instance_type = local.instance_type

  vpc_security_group_ids      = [""]
  vpc_security_group_ids      = [dependency.security_group_web.outputs.security_group_id, dependency.security_group_ssh.outputs.security_group_id]
  subnet_id                   = dependency.vpc.outputs.public_subnets[0]
  ami                         = local.ami_id
  associate_public_ip_address = true
  key_name                    = "chris-key"

  user_data = <<EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install -y nginx
  sudo systemctl start nginx
  sudo systemctl enable nginx
  EOF

  tags = {
    Environment = local.environment
  }
}