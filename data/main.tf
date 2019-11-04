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

module "data_vpc" {
  #source = "../primitives/vpc"
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
    Admin_implementation = "${var.name}"
    Tf_modules_version = "${chomp(file("../VERSION"))}"
    KubernetesCluster = "${var.name}"
  }
}

resource "aws_cloudwatch_log_group" "this_log_group" {
  retention_in_days = 30
  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }
}

module "kafka_server" {
  source = "../primitives/instance"
  name = "kafka"
  stack_name = "${var.name}"
  chef_environment = "${var.env}"
  subnet_id = "${module.data_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}", "${aws_security_group.kafka_sg.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  associate_public_ip = "true"
  run_list = ["role[kafka]"]
  chef_server_url = "${var.chef_server_url}"
  private_key = "${var.private_key}"
}

module "elasticsearch_server" {
  source = "../primitives/instance"
  name = "elasticsearch"
  stack_name = "${var.name}"
  chef_environment = "${var.env}"
  subnet_id = "${module.data_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}", "${aws_security_group.elasticsearch_sg.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[elasticsearch]"]
  private_key = "${var.private_key}"
}

module "cassandra_server" {
  source = "../primitives/instance"
  name = "cassandra"
  stack_name = "${var.name}"
  chef_environment = "${var.env}"
  subnet_id = "${module.data_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}", "${aws_security_group.cassandra_sg.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[cassandra]"]
  private_key = "${var.private_key}"
}

module "cassandra_server_3" {
  source = "../primitives/instance"
  name = "cassandra_3"
  stack_name = "${var.name}"
  chef_environment = "${var.env}"
  subnet_id = "${module.data_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}", "${aws_security_group.cassandra_sg.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[cassandra3]"]
  private_key = "${var.private_key}"
}

module "mongodb" {
  source = "../primitives/instance"
  name = "mongodb"
  stack_name = "${var.name}"
  chef_environment = "${var.env}"
  subnet_id = "${module.data_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}", "${aws_security_group.mongodb_sg.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[mongodb]"]
  private_key = "${var.private_key}"
}