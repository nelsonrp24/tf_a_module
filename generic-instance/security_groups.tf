# basic allow ssh from everywhere group
resource "aws_security_group" "default_sg" {
  name        = "${var.name}"
  description = "Default security group for any instance in ${var.name}"
  vpc_id      = "${module.application_vpc.vpc_id}"

  tags {
    Name = "${var.name}_default_sg"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]                         # This should be locked down
  security_group_id = "${aws_security_group.default_sg.id}"
}

resource "aws_security_group_rule" "allow_outbound" {
  type        = "egress"
  from_port   = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]
  to_port     = 0

  security_group_id = "${aws_security_group.default_sg.id}"
}

resource "aws_security_group" "public_web" {
  name = "${var.name}-public_web"
  description = "Web access"
  vpc_id = "${module.application_vpc.vpc_id}"

  tags {
    Name = "${var.name}_public_web"
  }
}

resource "aws_security_group_rule" "allow_http" {
  from_port = 80
  protocol = "tcp"
  security_group_id = "${aws_security_group.public_web.id}"
  to_port = 80
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https" {
  from_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.public_web.id}"
  to_port = 443
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}
