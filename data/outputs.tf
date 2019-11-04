output "name" {
  value = "${var.name}"
}

# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.data_vpc.vpc_id}"
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value = "${module.data_vpc.vpc_cidr_block}"
}
# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.data_vpc.private_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.data_vpc.public_subnets}"]
}

# Route tables
output "public_route_table_ids" {
  value = ["${module.data_vpc.public_route_table_ids}"]
}

output "private_route_table_ids" {
  value = ["${module.data_vpc.private_route_table_ids}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.data_vpc.nat_public_ips}"]
}

# Servers
output "kafka_server_ip" {
  description = "Public IP of the kafka server"
  value = "${module.kafka_server.public_ip}"
}

output "elasticsearch_server_ip" {
  description = "Public IP of the ELK stack"
  value = "${module.elasticsearch_server.public_ip}"
}

output "elasticsearch_logging_dest_ip" {
  description = "private"
  value = "${module.elasticsearch_server.private_ip}"
}

# Security groups
output "elasticsearch_sg_id" {
  value = "${aws_security_group.elasticsearch_sg.id}"
}

output "kafka_sg_id" {
  value = "${aws_security_group.kafka_sg.id}"
}
