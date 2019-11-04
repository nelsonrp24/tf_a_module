resource "aws_security_group" "postgres_sg" {
  name = "${var.db_name}-postgresql"
  description = "postgresql access"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.db_name}_postgresql_sg"
  }
}

resource "aws_security_group_rule" "allow_postgresql" {
  from_port = 5432
  protocol = "tcp"
  security_group_id = "${aws_security_group.postgres_sg.id}"
  to_port = 5432
  type = "ingress"
  cidr_blocks = ["${var.cidr_ingress}"]
}