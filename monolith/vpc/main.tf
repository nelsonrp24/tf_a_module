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

module "vpc_module" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}"
  cidr = "${var.vpc_cidr}"

  azs             = "${var.azs}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  enable_nat_gateway = true
  enable_vpn_gateway = true

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true 

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
    Vpc_implementation = "${var.name}"
    Tf_modules_version = "${chomp(file("../../VERSION"))}"
  }
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name    = "sg_${var.name}"
  vpc_id  = "${module.vpc_module.vpc_id}"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["https-443-tcp", "ssh-tcp", "http-8080-tcp"]

  ingress_with_cidr_blocks = [{
      from_port = 8000
      to_port = 8000
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
  },{
      from_port = 8091
      to_port = 8092
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
  }
  ]

  egress_rules  = ["all-all"]

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
    SecurityGroup_implementation = "${var.name}"
    Tf_modules_version = "${chomp(file("../../VERSION"))}"
  }
}

module "public_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name           = "nodes_${var.name}"
  instance_count = "${var.public_instance_count}"
  ami            = "${var.public_ami}"
  instance_type  = "${var.public_instance_type}"
  subnet_id      = "${module.vpc_module.public_subnets[0]}"
  key_name       = "${var.key_name}"
  vpc_security_group_ids = ["${module.security_group.this_security_group_id}"]
  associate_public_ip_address = "true"

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
    Instance_implementation = "${var.name}"
    Tf_modules_version = "${chomp(file("../../VERSION"))}"
  }  
}

module "private_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name           = "nodes_${var.name}"
  instance_count = "${var.private_instance_count}"
  ami            = "${var.private_ami}"
  instance_type  = "${var.private_instance_type}"
  subnet_id      = "${module.vpc_module.private_subnets[0]}"
  key_name       = "${var.key_name}"  
  vpc_security_group_ids = ["${module.security_group.this_security_group_id}"]

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
    Instance_implementation = "${var.name}"
    Tf_modules_version = "${chomp(file("../../VERSION"))}"
  }  
}
