terraform {
  backend "s3" {}
}

provider "aws" {
 region  = "${var.region}"
 version = "~> 1.7"
}

module "devops_jenkins" {
  source = "../primitives/instance"
  name = "${var.name}"
  stack_name = "${var.name}"
  chef_environment = "${var.chef_environment}"
  subnet_id = "${var.subnet_id}"
  security_groups = "${var.security_groups}"
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_pem}"
  key_name = "${var.aws_key_pair_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[jenkins]"]
  private_key = "${var.private_key}"
}