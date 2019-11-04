output "name" {
  value = "${var.name}"
}

# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.admin_vpc.vpc_id}"
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value = "${module.admin_vpc.vpc_cidr_block}"
}
# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.admin_vpc.private_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.admin_vpc.public_subnets}"]
}

# Route tables
output "public_route_table_ids" {
  value = ["${module.admin_vpc.public_route_table_ids}"]
}

output "private_route_table_ids" {
  value = ["${module.admin_vpc.private_route_table_ids}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.admin_vpc.nat_public_ips}"]
}

# Servers
output "vpn_server_ip" {
  description = "Public IP of the VPN server"
  value = "${module.vpn_server.public_ip}"
}

output "monitoring_server_ip" {
  description = "Public IP of the ELK stack"
  value = "${module.monitoring.public_ip}"
}

output "monitoring_logging_dest_ip" {
  description = "private"
  value = "${module.monitoring.private_ip}"
}

# Security groups
output "monitoring_sg_id" {
  value = "${aws_security_group.elk_sg.id}"
}

output "openvpn_sg_id" {
  value = "${aws_security_group.openvpn_sg.id}"
}
