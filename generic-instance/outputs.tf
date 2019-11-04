output "name" {
  value = "${var.name}"
}

# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.application_vpc.vpc_id}"
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value = "${module.application_vpc.vpc_cidr_block}"
}
# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.application_vpc.private_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.application_vpc.public_subnets}"]
}

# Route tables
output "public_route_table_ids" {
  value = ["${module.application_vpc.public_route_table_ids}"]
}

output "private_route_table_ids" {
  value = ["${module.application_vpc.private_route_table_ids}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.application_vpc.nat_public_ips}"]
}

# Servers
output "application_server_ip" {
  description = "Public IP of the VPN server"
  value = "${module.application.public_ip}"
}