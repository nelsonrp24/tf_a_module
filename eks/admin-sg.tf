resource "aws_security_group" "admin-eks" {
  name = "${var.cluster-name}-admin"
  description = "Default security group for any instance in ${var.cluster-name}"
  vpc_id = "${aws_vpc.demo.id}"

  tags  = {
    Name = "${var.cluster-name}_admin-eks"
  }
}



resource "aws_security_group_rule" "allow_outbound" {
  type = "egress"
  from_port = 0
  protocol = -1
  cidr_blocks = ["0.0.0.0/0"]
  to_port = 0

  security_group_id = "${aws_security_group.admin-eks.id}"
}