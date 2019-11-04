# basic allow ssh from everywhere group

resource "aws_security_group" "default_sg" {
  name = "${var.name}"
  description = "Default security group for any instance in ${var.name}"
  vpc_id = "${module.saas_vpc.vpc_id}"

  tags {
    Name = "${var.name}_default_sg"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # This should be locked down
  security_group_id = "${aws_security_group.default_sg.id}"
}

resource "aws_security_group_rule" "allow_outbound" {
  type = "egress"
  from_port = 0
  protocol = -1
  cidr_blocks = ["0.0.0.0/0"]
  to_port = 0

  security_group_id = "${aws_security_group.default_sg.id}"
}
