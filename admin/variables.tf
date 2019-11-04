variable "region" {
  default = "us-west-2"
}

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

variable "ip_address_workers" {
  type = "list"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "root_volume_size" {
  default = "50"
}

variable "jenkins_instance_count"{
  default = "1"
}

variable "monitoring_instance_count"{
  default = "1"
}

variable "prometheus_instance_count"{
  default = "1"
}

variable "jaeger_instance_count"{
  default = "1"
}

variable "sonarqube_instance_count"{
  default = "1"
}

variable "vpn_instance_count"{
  default = "1"
}

variable "harbor_instance_count"{
  default = "0"
}



