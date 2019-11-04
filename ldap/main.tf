terraform {
  backend "s3" {}
}

provider "aws" {
 region  = "${var.region}"
 version = "~> 1.7"
}

resource "aws_security_group" "ldap" {
  name        = "ldap"
  description = "Default security group for any instance in ldap"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.name}_ldap_sg"
  }
}

# resource "aws_security_group_rule" "ldap" {
#   type              = "ingress"
#   from_port         = 389
#   to_port           = 389
#   protocol          = "tcp"
#   cidr_blocks = ["${var.vpc_cidr}"]
#   security_group_id = "${aws_security_group.ldap.id}"
# }

resource "aws_security_group_rule" "ldap" {
  count = "${length(var.ip_address_ldap) > 0 ? length(var.ip_address_ldap) : 0}"
  type              = "ingress"
  from_port         = 389
  to_port           = 389
  protocol          = "tcp"
  cidr_blocks       = ["${element(var.ip_address_ldap, count.index)}"]
  security_group_id = "${aws_security_group.ldap.id}"
}


module "ldap" {
  source = "../primitives/instance"
  name = "ldap"
  stack_name = "${var.name}"
  chef_environment = "${var.chef_environment}"
  subnet_id = "${var.subnet_id}"
  security_groups = ["${aws_security_group.ldap.id}", "${var.security_groups}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_pem}"
  key_name = "${var.aws_key_pair_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[ldap]"]
  private_key = "${var.private_key}"
}