# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.saas_vpc.vpc_id}"
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.saas_vpc.private_subnets}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.saas_vpc.nat_public_ips}"]
}

# k8s info
output "k8s_api" {
  value = "${module.kops_k8s.cluster_api}"
}

output "kops_bucket" {
  value = "${module.kops_k8s.kops_bucket_name}"
}

output "monitoring_ip" {
  value = "${module.monitoring.public_ip}"
}
