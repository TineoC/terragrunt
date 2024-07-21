locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  s3_bucket_name      = "chris-devopsdemo2024-terraform-state"
  s3_bucket_region    = "us-east-1"
  dynamodb_table_name = "my-terraform-locks"
}

remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    region         = local.region_vars.locals.aws_region
    bucket         = local.s3_bucket_name
    key            = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = local.dynamodb_table_name
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
    region = "${local.region_vars.locals.aws_region}"
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

// generate output for S3 bucket name and region
generate "s3_bucket_output" {
  path      = "s3_bucket_output.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  output "s3_bucket_name" {
    value = "${local.s3_bucket_name}"
  }
  output "s3_bucket_region" {
    value = "${local.s3_bucket_region}"
  }
  EOF
}

generate "dynamodb_table_output" {
  path      = "dynamodb_table_output.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  output "dynamodb_table_name" {
    value = "${local.dynamodb_table_name}"
  }
  EOF
}