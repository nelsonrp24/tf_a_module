terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

/**
* Setup AWS provider.
*/
provider "aws" {
 region  = "${var.region}"
 # version = "~> 1.7"
}

module "admin_vpc" {
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

 module "vpn_server" {
  source = "../primitives/instance"
  name = "vpn"
  stack_name = "${var.name}"
  chef_environment = "${var.env}"
  subnet_id = "${module.admin_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}", "${aws_security_group.openvpn_sg.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  associate_public_ip = "true"
  run_list = ["role[vpn]"]
  chef_server_url = "${var.chef_server_url}"
  private_key = "${var.private_key}"
  instance_count = "${var.vpn_instance_count}"
  eip_count = "${var.vpn_instance_count}"
}

module "monitoring" {
  source = "../primitives/instance"
  name = "monitoring"
  stack_name = "${var.name}"
  chef_environment = "${var.env}"
  subnet_id = "${module.admin_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}", "${aws_security_group.elk_sg.id}", "${aws_security_group.eks_workers.id}", "${aws_security_group.public_web.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[monitoring]"]
  private_key = "${var.private_key}"
  instance_type = "t2.large"
  eip_count = "${var.monitoring_instance_count}"
  instance_count = "${var.monitoring_instance_count}"
  is_standard_instance = "false"
}

module "jenkins" {
  source = "../primitives/instance"
  name = "CICD"
  stack_name = "${var.name}"
  chef_environment = "${var.env}"
  subnet_id = "${module.admin_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}", "${aws_security_group.jenkins_sg.id}", "${aws_security_group.public_web.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  chef_version = "14"
  key_name = "${var.aws_key_pair_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[jenkins]"]
  private_key = "${var.private_key}"
  eip_count = "${var.jenkins_instance_count}"
  usr_partition_percentage = "20"
  instance_count = "${var.jenkins_instance_count}"
  is_standard_instance = "false"
  instance_type = "m4.xlarge"
}

module "prometheus" {
  instance_count = "${var.prometheus_instance_count}"
  source = "../primitives/instance"
  name = "metrics"
  stack_name = "${var.name}"
  chef_environment = "${var.name}"
  subnet_id = "${module.admin_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}", "${aws_security_group.metrics_sg.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[metrics]"]
  private_key = "${var.private_key}"
  eip_count = "${var.prometheus_instance_count}"
}

module "jaeger" {
  source = "../primitives/instance"
  name = "tracing"
  stack_name = "${var.name}"
  chef_environment = "${var.name}"
  subnet_id = "${module.admin_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}", "${aws_security_group.tracing_sg.id}", "${aws_security_group.public_web.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[tracing]"]
  private_key = "${var.private_key}"
  instance_count = "${var.jaeger_instance_count}"
}

module "sonarqube" {
  source = "../primitives/instance"
  name = "sonarqube"
  stack_name = "${var.name}"
  chef_environment = "${var.name}"
  subnet_id = "${module.admin_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}", "${aws_security_group.public_web.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[sonarqube]"]
  private_key = "${var.private_key}"
  instance_type = "m4.xlarge"
  eip_count = "${var.sonarqube_instance_count}"
  instance_count = "${var.sonarqube_instance_count}"
}

module "harbor" {
  instance_count = "${var.harbor_instance_count}"
  source = "../primitives/instance"
  name = "harbor"
  stack_name = "${var.name}"
  chef_environment = "${var.name}"
  subnet_id = "${module.admin_vpc.public_subnets[0]}"
  security_groups = ["${aws_security_group.default_sg.id}", "${aws_security_group.public_web.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.aws_key_pair_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[harbor]"]
  root_volume_size = "200"
  usr_partition_percentage = "15"
  private_key = "${var.private_key}"
  instance_type = "m4.xlarge"
  eip_count = "${var.harbor_instance_count}"
  is_standard_instance = "false"
}