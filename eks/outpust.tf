output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${aws_vpc.demo.id}"
}

output "route_table_id" {
  description = "List of IDs route tables"
  value       = ["${aws_route_table.demo.id}"]
}


