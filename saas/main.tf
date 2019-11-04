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

module "saas_vpc" {
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
    Saas_implementation = "${var.name}"
    Tf_modules_version = "${chomp(file("../VERSION"))}"
    KubernetesCluster = "${var.name}"
  }
}

module "kops_k8s" {
  source                      = "../primitives/kops_k8s_cluster"
  cluster_name = "${var.name}"
  vpc_id = "${module.saas_vpc.vpc_id}"
  cidr = "${var.vpc_cidr}"
  aws_key_pair_name = "${var.aws_key_pair_name}"
  azs             = "${var.azs}"
  domain_name = "${var.domain_name}"
  kubernetes_subnets = "${var.kubernetes_subnets}"
  igw_id = "${module.saas_vpc.igw_id}"
  route_table_id = "${element(concat(module.saas_vpc.public_route_table_ids, list("")), 0)}"
  ssh_public_key_path = "${var.ssh_public_key_path}"
}

resource "aws_cloudwatch_log_group" "this_log_group" {
  retention_in_days = 30
  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }
}

module "demo_instance" {
  source = "../primitives/instance"
  name = "demo-instance"
  stack_name = "${var.name}"
  chef_environment = "${var.name}"
  subnet_id = "${module.saas_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  associate_public_ip = "true"
  run_list = "role[base]"
}

module "monitoring" {
  source = "../primitives/instance"
  name = "monitoring"
  stack_name = "${var.name}"
  chef_environment = "${var.name}"
  subnet_id = "${module.saas_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  associate_public_ip = "true"
  run_list = "role[monitoring]"
}
