output "this_db_instance_address" {
  description = "The address of the RDS instance"
  value       = "${module.db.this_db_instance_address}"
}

output "this_db_instance_endpoint" {
  description = "The connection endpoint"
  value       = "${module.db.this_db_instance_endpoint}"
}

output "this_db_instance_username" {
  description = "The master username for the database"
  value       = "${module.db.this_db_instance_username}"
}

output "this_db_instance_password" {
  description = "The database password"
  value       = "${module.db.this_db_instance_password}"
}

output "this_db_instance_port" {
  description = "The database port"
  value       = "${module.db.this_db_instance_port}"
}