module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name          = "web-server-${var.environment}"
  instance_type = var.instance_type
  key_name      = "chris"

  ami                    = "ami-04a81a99f5ec58529"
  subnet_id              = var.public_subnet
  vpc_security_group_ids = var.vpc_security_group_ids

  associate_public_ip_address = true

  user_data = file("user-data.sh")

  tags = {
    IAC         = "true"
    Environment = var.environment
    Region      = var.region
  }
}
