resource "aws_security_group" "eks_workers" {
  name        = "eks_workers_metrics"
  description = "Default security group for any instance in eks_workers_metrics"
  vpc_id      = "${module.admin_vpc.vpc_id}"

  tags = {
    Name = "${var.name}_eks_nodes_sg"
  }
}

resource "aws_security_group_rule" "allow_metrics_worker" {
  count = "${length(var.ip_address_workers) > 0 ? length(var.ip_address_workers) : 0}"
  type              = "ingress"
  from_port         = 9200
  to_port           = 9200
  protocol          = "tcp"
  cidr_blocks       = ["${element(var.ip_address_workers, count.index)}"]
  security_group_id = "${aws_security_group.eks_workers.id}"
}

resource "aws_security_group_rule" "allow_metrics_worker_5044" {
  count = "${length(var.ip_address_workers) > 0 ? length(var.ip_address_workers) : 0}"
  type              = "ingress"
  from_port         = 5044
  to_port           = 5044
  protocol          = "tcp"
  cidr_blocks       = ["${element(var.ip_address_workers, count.index)}"]
  security_group_id = "${aws_security_group.eks_workers.id}"
}

