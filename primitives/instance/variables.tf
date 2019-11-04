variable "chef_server_url" {}

variable "chef_user" {}

variable "chef_pem" {}

variable "key_name" {}

variable "subnet_id" {}

variable "security_groups" {
  type = "list"
}

variable "private_key" {}

variable "disable_api_termination" {
  default = "false"
}

variable "associate_public_ip" {
  default = "false"
}

variable "stack_name" {}

variable "name" {}

variable "run_list" {
  type = "list"
}

variable "chef_environment" {}

variable "chef_version" {
  default = "13"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "root_volume_size" {
  default = "50"
}

variable "eip_count" {
  default = "0"
}

variable "instance_count" {
  default = "1"
}

variable "usr_partition_percentage" {
  default = "80"
}

# This is the remaining disk space after allocating to usr partition. 
# Hence this is set to 100%.
variable "var_partition_percentage" {
  default = "100"
}

variable "ami_os_name_filter_by_value"{
  default = "CentOS-7*"
}

variable "is_standard_instance" {
  default = "true"
}