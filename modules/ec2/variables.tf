variable "environment" {
  description = "The environment for the resources"
}

variable "region" {
  description = "The region for the resources"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The type of instance to launch"
  default     = "t2.micro"
}

variable "public_subnet" {
  description = "The public subnets to launch the EC2 instance in"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "The security group to attach to the EC2 instance"
  type        = list(string)
  default     = []
}
