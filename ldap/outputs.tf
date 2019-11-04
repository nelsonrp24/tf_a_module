output "instance_name" {
  value = "${var.name}"
}

output "ldap_public_ip" {
  description = "Public IP of the LDAP server"
  value = "${module.ldap.public_ip}"
}