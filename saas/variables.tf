variable "region" {
  default = "us-west-2"
}

variable "name" {
  type = "string"
  description = "the name of this particular instance of the saas backend"
}

variable "env" {
  type = "string"
  description = "how we represent this phase of the lifecycle of the saas, eg dev, stage, prod"
}

variable "vpc_cidr" {
  description = "the cidr to be used by the saas vpc"
}

# I could also be persuaded to make this auto-discover via remote state inspection
variable "admin_vpc_id" {
  description = "the vpc_id of the admin vpc we should peer with. should be in same region"
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

variable "kubernetes_subnets" {
  type = "list"
}

variable "aws_key_pair_name" {}

variable "ssh_public_key_path" {}

variable "domain_name" {}

variable "chef_user" {}

variable "chef_user_key" {}

variable "tfstate_global_bucket" {}

variable "tfstate_global_bucket_region" {}

variable "terragrunt_remote_admin_state_key" {}
