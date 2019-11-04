output "vpc_id" {
  description = "The ID for VPC"
  value       = "${module.vpc_module.vpc_id}"
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc_module.private_subnets}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.vpc_module.nat_public_ips}"]
}

output "public_instance_ips" {
  description = "The IP for public instance"
  value       = "${module.public_instance.public_ip}"
}