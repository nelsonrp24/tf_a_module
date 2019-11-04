variable "region" {}

variable "name" {
  type = "string"
  description = "the name of this particular instance of the admin/devops stack"
}

variable "env" {
  type = "string"
  description = "how we represent this phase of the lifecycle of the admin, eg dev, stage, prod"
}

variable "vpc_cidr" {
  description = "the cidr to be used by the admin vpc"
}

variable "azs" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}

variable "aws_key_pair_name" {}

variable "ssh_public_key_path" {}

variable "chef_user" {}

variable "chef_user_key" {}
variable "chef_server_url" {}

variable "private_key" {}


variable "ip_address_kafka" {
  type = "list"
}

variable "ip_address_elasticsearch" {
  type = "list"
}

variable "ip_address_cassandra" {
  type = "list"
}

variable "ip_address_mongodb" {
  type = "list"
}
#variable "ip_address_workers" {
#  type = "list"
#}

