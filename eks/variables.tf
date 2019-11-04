variable "cluster-name" {}
variable "cidr_block" {}
variable "subnets" {
  type = "list"
}
variable "env" {}
variable "zones" {
  type = "list"
}
variable "instance_type" {
  default = "m4.large"
}

variable "worker_disk_size" {
  default = 20
}

variable "keypair" {
  default = "aaxis-devops-keypair"
}
