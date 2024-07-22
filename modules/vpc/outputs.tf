output "vpc_id" {
  value = module.vpc.vpc_id
}

//output public subnets
output "public_subnets" {
  value = module.vpc.public_subnets
}
