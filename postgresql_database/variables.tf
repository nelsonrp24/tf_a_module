variable "db_name" {
  type = "string"
  description = "DB name"
}

variable "username" {
  type = "string"
  description = "DB Username"
}

variable "password" {
  type = "string"
  description = "DB Password"
}

variable "port" {
  type = "string"
}

variable "env" {
  type = "string"
  default = "dev"
}

variable "vpc_id" {
  type = "string"
}

variable "cidr_ingress" {
  type = "list"
}
