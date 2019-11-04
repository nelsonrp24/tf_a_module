variable "region" {
    default = "us-west-2"
}

variable "name" {
    type = "string"
    description = "name to be used by vpc"
}

variable "vpc_cidr" {
    type = "string"
    description = "the cidr block for the VPC"
}

variable "azs" {
    type = "list"
    description = "list of availability zones in the region"
}

variable "private_subnets" {
    type = "list"
    description = "a list of private subnets inside VPC"
}

variable "public_subnets" {
    type = "list"
    description = "a list of public subnets inside VPC"
}

variable "env" {
    type = "string"
    description = "environment name"
}

variable "key_name" {
    type = "string"
    description = "the name of the key pair that will be used for log in to instance"
}

variable "public_instance_count" {
    type = "string"
    default = "0"
    description = "number of instances to be created"
}

variable "public_ami" {
    type = "string"
    description = "ami for the current region"
}

variable "public_instance_type" {
    type = "string"
    description = "instance type for the current region"
}

variable "private_instance_count" {
    type = "string"
    default = "0"
    description = "number of instances to be created"
}

variable "private_ami" {
    type = "string"
    description = "ami for the current region"
}

variable "private_instance_type" {
    type = "string"
    description = "instance type for the current region"
}