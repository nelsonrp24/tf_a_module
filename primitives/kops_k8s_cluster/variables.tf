variable "vpc_id" {
  type = "string"
}

variable "cidr" {
  type = "string"
  description = "VPC Cidr"
}

variable "region" {
  type = "string"
  default = "us-west-2"
}

variable "cluster_name" {
  type = "string"
}

variable "azs" {
  type = "list"
}

variable "aws_key_pair_name" {}

variable "domain_name" {}

variable "kubernetes_subnets" {
  type = "list"
}

variable "igw_id" {}

variable "route_table_id" {}

variable "ssh_public_key_path" {}
