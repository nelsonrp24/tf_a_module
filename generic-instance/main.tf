terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

/**
* Setup AWS provider.
*/
provider "aws" {
 region  = "${var.region}"
 version = "~> 1.7"
}

module "application_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}"
  cidr = "${var.vpc_cidr}"

  azs             = "${var.azs}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true
  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
    Tf_modules_version = "${chomp(file("../VERSION"))}"
  }
}

resource "aws_cloudwatch_log_group" "this_log_group" {
  retention_in_days = 30
  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }
}

 module "application" {
  source = "../primitives/instance"
  name = "application"
  stack_name = "${var.name}"
  chef_environment = "${var.env}"
  subnet_id = "${module.application_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}","${aws_security_group.public_web.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  associate_public_ip = "true"
  run_list = ["role[base]"]
  chef_server_url = "${var.chef_server_url}"
  private_key = "${var.private_key}"
  eip_count = "${var.application_instance_count}"
  instance_count = "${var.application_instance_count}"
  ami_os_name_filter_by_value = "${var.ami_os_name_filter_by_value}"
  root_volume_size = "200"
}