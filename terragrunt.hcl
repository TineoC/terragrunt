locals {
  name        = "chris-terragrunt-demo"
  region      = "us-east-1"
  environment = "dev"
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    region         = local.region
    bucket         = "chris-devopsdemo2024-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "my-terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region = "${local.region}"
  }
  EOF
}

generate "provider_version" {
  path      = "provider_version_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  }
EOF
}