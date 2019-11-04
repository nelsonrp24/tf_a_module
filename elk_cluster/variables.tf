variable "vpc_id"{}

variable "vpc_cidr"{}

variable "subnets_id" {
  type = "list"

}

variable "name"{}

variable "ami_os_name_filter_by_value"{
  default = "CentOS-7*"
}

variable "kibana_instance_type" {}

variable "elasticsearch_number_of_instances" {
  default = 3
}

variable "elasticsearch_instance_type" {
  default = "t2.medium"
}

variable "logstash_number_of_instances" {
  default = 2
}

variable "logstash_instance_type" {
  default = "t2.medium"
}


variable "kibana_number_of_instances" {
  default = 2
}

variable "key_name" {}

variable "kibana_security_groups" {
  type = "list"
}

variable "chef_server_url" {}

variable "chef_user" {}

variable "chef_user_key" {}

variable "chef_version" {
  default = "13"
}

variable "env" {}

variable "private_key" {}