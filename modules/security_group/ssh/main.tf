module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh-access-${var.environment}-sg"
  description = "Security group for web-server with SSH ports open for specific Public IP"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["148.255.245.25/32"]

  tags = {
    IAC         = "true"
    Environment = var.environment
    Region      = var.region
  }
}
