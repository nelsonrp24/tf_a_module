output "name" {
  value = "${var.name}"
}

output "file_system_id" {
  value = "${aws_efs_file_system.efs.id}"
}

output "dns_name" {
  value = "${aws_efs_file_system.efs.dns_name}"
}

