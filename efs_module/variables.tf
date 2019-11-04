variable "name" {
  type    = "string"
}

variable "encrypted" {
  default = false
}

variable "vpc_id" {
  description = "(Required) The VPC ID where NFS security groups will be."
  type        = "string"
}

variable "performance_mode" {
  description = "(Optional) The performance mode of your file system."
  type        = "string"
  default     = "generalPurpose"
}

variable "subnets_ids" {
  type = "list"
}

variable "allowed_cidr_blocks" {
  description = "(Required) A comma separated list of CIDR blocks allowed to mount target."
  type        = "list"
}