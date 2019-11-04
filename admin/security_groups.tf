# basic allow ssh from everywhere group
resource "aws_security_group" "default_sg" {
  name        = "${var.name}"
  description = "Default security group for any instance in ${var.name}"
  vpc_id      = "${module.admin_vpc.vpc_id}"

  tags = {
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

# every machine should allow the
resource "aws_security_group_rule" "node_exporter" {
  from_port = 9100
  protocol = "tcp"
  security_group_id = "${aws_security_group.default_sg.id}"
  to_port = 9100
  type = "ingress"
  source_security_group_id = "${aws_security_group.elk_sg.id}"
}
resource "aws_security_group_rule" "allow_outbound" {
  type        = "egress"
  from_port   = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]
  to_port     = 0

  security_group_id = "${aws_security_group.default_sg.id}"
}

# openvpn rules for vpn box
resource "aws_security_group" "openvpn_sg" {
  name        = "${var.name}-openvpn"
  #count       = "${var.vpn_instance_count}"
  description = "OpenVPN access"
  vpc_id      = "${module.admin_vpc.vpc_id}"

  tags = {
    Name = "${var.name}_OpenVPN_sg"
  }
}

resource "aws_security_group_rule" "allow_openvpn" {
  count             = "${var.vpn_instance_count}"
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]                         # This should be locked down
  security_group_id = "${aws_security_group.openvpn_sg.id}"
}

# ELK/monitoring box
resource "aws_security_group" "elk_sg" {
  #count       = "${var.monitoring_instance_count}"
  name = "${var.name}-elk"
  description = "ELK access rules"
  vpc_id = "${module.admin_vpc.vpc_id}"

  tags = {
    Name = "${var.name}_ELK_sg"
  }
}

resource "aws_security_group_rule" "allow_kibana" {
  count       = "${var.monitoring_instance_count}"
  from_port = 5601
  protocol = "tcp"
  security_group_id = "${aws_security_group.elk_sg.id}"
  to_port = 5601
  type = "ingress"
  # everything in the entire admin VPC can get to kibana, and thus us via VPN
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_elasticsearch" {
  count       = "${var.monitoring_instance_count}"
  from_port = 9200
  protocol = "tcp"
  security_group_id = "${aws_security_group.elk_sg.id}"
  to_port = 9200
  type = "ingress"
  # everything in the entire admin VPC can get to kibana, and thus us via VPN
  cidr_blocks = ["${var.vpc_cidr}"]
}

# jenkins rules for cicd box
resource "aws_security_group" "jenkins_sg" {
  #count       = "${var.jenkins_instance_count}"
  name        = "${var.name}-jenkins"
  description = "CI/CD access"
  vpc_id      = "${module.admin_vpc.vpc_id}"

  tags = {
    Name = "${var.name}_cicd_sg"
  }
}

resource "aws_security_group_rule" "allow_jenkins" {
  count       = "${var.jenkins_instance_count}"
  from_port = 8080
  protocol = "tcp"
  security_group_id = "${aws_security_group.jenkins_sg.id}"
  to_port = 8080
  type = "ingress"
  # everything in the entire admin VPC can get to jenkins, and thus us via VPN
  cidr_blocks = ["${var.vpc_cidr}"]
}


# Prometheus rules for metrics box
resource "aws_security_group" "metrics_sg" {
  #count = "${var.prometheus_instance_count}"
  name = "${var.name}-metrics"
  description = "Metrics access"
  vpc_id = "${module.admin_vpc.vpc_id}"

  tags = {
    Name = "${var.name}_metrics_sg"
  }
}

resource "aws_security_group_rule" "allow_prometheus" {
  count = "${var.prometheus_instance_count}"
  from_port = 9090
  protocol = "tcp"
  security_group_id = "${aws_security_group.metrics_sg.id}"
  to_port = 9090
  type = "ingress"
  # everything in the entire admin VPC can get to jenkins, and thus us via VPN
  cidr_blocks = ["${var.vpc_cidr}"]
}


# Jaeger rules for tracing box
resource "aws_security_group" "tracing_sg" {
  #count = "${var.jaeger_instance_count}"
  name = "${var.name}-tracing"
  description = "tracing access"
  vpc_id = "${module.admin_vpc.vpc_id}"

  tags = {
    Name = "${var.name}_tracing_sg"
  }
}

resource "aws_security_group_rule" "allow_jaeger_14267" {
  count = "${var.jaeger_instance_count}"
  from_port = 14267
  protocol = "tcp"
  security_group_id = "${aws_security_group.tracing_sg.id}"
  to_port = 14267
  type = "ingress"
  # everything in the entire admin VPC can get to jenkins, and thus us via VPN
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_jaeger_16686" {
  count = "${var.jaeger_instance_count}"
  from_port = 16686
  protocol = "tcp"
  security_group_id = "${aws_security_group.tracing_sg.id}"
  to_port = 16686
  type = "ingress"
  # everything in the entire admin VPC can get to jenkins, and thus us via VPN
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_jaeger_14269" {
  count = "${var.jaeger_instance_count}"
  from_port = 14269
  protocol = "tcp"
  security_group_id = "${aws_security_group.tracing_sg.id}"
  to_port = 14269
  type = "ingress"
  # everything in the entire admin VPC can get to jenkins, and thus us via VPN
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_jaeger_14268" {
  count = "${var.jaeger_instance_count}"
  from_port = 14268
  protocol = "tcp"
  security_group_id = "${aws_security_group.tracing_sg.id}"
  to_port = 14268
  type = "ingress"
  # everything in the entire admin VPC can get to jenkins, and thus us via VPN
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_jaeger_5775" {
  count = "${var.jaeger_instance_count}"
  from_port = 5775
  protocol = "udp"
  security_group_id = "${aws_security_group.tracing_sg.id}"
  to_port = 5775
  type = "ingress"
  # everything in the entire admin VPC can get to jenkins, and thus us via VPN
  cidr_blocks = ["0.0.0.0/0"]
}

# Public http rules
resource "aws_security_group" "public_web" {
  name = "${var.name}-public_web"
  description = "tracing access"
  vpc_id = "${module.admin_vpc.vpc_id}"

  tags = {
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
