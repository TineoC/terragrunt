variable "environment" {
  type        = string
  description = "The environment for the resources"
}

variable "region" {
  type        = string
  description = "The region for the resources"
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}
