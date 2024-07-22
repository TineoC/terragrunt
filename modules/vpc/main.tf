module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-${var.environment}"
  cidr = var.cidr

  azs            = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnets = var.public_subnets

  map_public_ip_on_launch = true

  public_subnet_tags = {
    Tier = "Public"
  }

  tags = {
    IAC         = "true"
    Environment = var.environment
    Region      = var.region
  }
}
