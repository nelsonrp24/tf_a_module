variable "region" {
  type = "string"
  description = "Instance name"
}

variable "name" {
  type = "string"
  description = "Instance name"
}

variable "chef_environment" {
  type = "string"
  description = "Chef environment"
}

variable "vpc_cidr" {}

variable "vpc_id" {}

variable "subnet_id" {
  type = "string"
  description = "Subnet ID"
}

variable "security_groups" {
  type = "list"
  description = "Security groups list"
}

variable "chef_user" {
  type = "string"
  description = "Chef User"
}

variable "chef_pem" {
  type = "string"
  description = "Chef key"
}

variable "aws_key_pair_name" {
  type = "string"
  description = "Key AWS name"
}

variable "chef_server_url" {
  type = "string"
  description = "Chef server URL"
}

variable "private_key" {
  type = "string"
  description = "SSH key Instance"
}

variable "ip_address_ldap" {
  type = "list"
}