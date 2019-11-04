resource "aws_security_group" "elk_cluster_default_sg" {
  name        = "${var.name}"
  description = "Default security group for any instance in ${var.name}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name}_elk_cluster_default_sg"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]                         # This should be locked down
  security_group_id = "${aws_security_group.elk_cluster_default_sg.id}"
}

resource "aws_security_group_rule" "allow_outbound" {
  type        = "egress"
  from_port   = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]
  to_port     = 0

  security_group_id = "${aws_security_group.elk_cluster_default_sg.id}"
}

resource "aws_security_group" "kibana" {
  name = "${var.name}-kibana"
  description = "kibana access rules"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name}_kibana_sg"
  }
}

resource "aws_security_group_rule" "allow_kibana_5601" {
  from_port = 5601
  protocol = "tcp"
  security_group_id = "${aws_security_group.kibana.id}"
  to_port = 5601
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_kibana_80" {
  from_port = 80
  protocol = "tcp"
  security_group_id = "${aws_security_group.kibana.id}"
  to_port = 80
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_kibana_443" {
  from_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.kibana.id}"
  to_port = 443
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "elasticsearch" {
  name = "${var.name}-elasticsearch"
  description = "elasticsearch access rules"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name}_elasticsearch_sg"
  }
}

resource "aws_security_group_rule" "allow_elasticsearch_9200" {
  from_port = 9200
  protocol = "tcp"
  security_group_id = "${aws_security_group.elasticsearch.id}"
  to_port = 9200
  type = "ingress"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_elasticsearch_9300" {
  from_port = 9300
  protocol = "tcp"
  security_group_id = "${aws_security_group.elasticsearch.id}"
  to_port = 9300
  type = "ingress"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group" "logstash" {
  name = "${var.name}-logstash"
  description = "logstash access rules"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name}_logstash_sg"
  }
}

resource "aws_security_group_rule" "allow_logstash_5400" {
  from_port = 5400
  protocol = "tcp"
  security_group_id = "${aws_security_group.logstash.id}"
  to_port = 5400
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}