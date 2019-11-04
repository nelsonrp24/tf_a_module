variable "domain_name" {
  type = "string"
  description = "top level domain (e.g. fastrobot.com)"
}

variable "cluster_name" {
  type = "string"
  description = "name of the cluster and DNS subdomain"
}

variable "our_cluster" {
  type = "string"
  description = "the cluster name (before k8s.local) used by all tags and names inside aws"
}

variable "max_nodes" {
  type = "string"
  description = "max size of node instance ASG"
}

variable "vpc_id" {}

variable "kubernetes_subnets" {
  type = "list"
}

variable "azs" {
  type = "list"
}
