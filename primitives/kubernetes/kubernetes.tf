// Heavily edited output from a kops cluster create --target=terraform
//

provider "aws" {
  region = "us-west-2"
}

resource "aws_autoscaling_attachment" "master-us-west-2a-masters-kubetest1-k8s-local" {
  elb                    = "${aws_elb.our_api.id}"
  autoscaling_group_name = "${aws_autoscaling_group.master-us-west-2a-masters-kubetest1-k8s-local.id}"
}

resource "aws_autoscaling_group" "master-us-west-2a-masters-kubetest1-k8s-local" {
  name                 = "master-us-west-2a.masters.kubetest1.k8s.local"
  launch_configuration = "${aws_launch_configuration.master-us-west-2a-masters-kubetest1-k8s-local.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.kubenet.0.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "${var.our_cluster}.k8s.local"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-west-2a.masters.kubetest1.k8s.local"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-us-west-2a"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "nodes-kubetest1-k8s-local" {
  name                 = "nodes.${var.our_cluster}.k8s.local"
  launch_configuration = "${aws_launch_configuration.nodes-k8s.id}"
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = ["${aws_subnet.kubenet.*.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "${var.our_cluster}.k8s.local"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.${var.our_cluster}.k8s.local"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "a-etcd-events-kubetest1-k8s-local" {
  availability_zone = "us-west-2a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "${var.our_cluster}.k8s.local"
    Name                 = "a.etcd-events.${var.our_cluster}.k8s.local"
    "k8s.io/etcd/events" = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "a-etcd-main-kubetest1-k8s-local" {
  availability_zone = "us-west-2a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "${var.our_cluster}.k8s.local"
    Name                 = "a.etcd-main.kubetest1.k8s.local"
    "k8s.io/etcd/main"   = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_elb" "our_api" {
  name = "api-${var.our_cluster}"

  listener = {
    instance_port     = 443
    instance_protocol = "TCP"
    lb_port           = 443
    lb_protocol       = "TCP"
  }

  security_groups = ["${aws_security_group.api-elb-kubetest1-k8s-local.id}"]
  subnets         = ["${aws_subnet.kubenet.*.id}"]

  health_check = {
    target              = "SSL:443"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 5
  }

  idle_timeout = 300

  tags = {
    KubernetesCluster = "${var.our_cluster}.k8s.local"
    Name              = "api.${var.our_cluster}.k8s.local"
  }
}

resource "aws_iam_instance_profile" "our_masters" {
  name = "masters.${var.our_cluster}.k8s.local"
  role = "${aws_iam_role.our_masters.name}"
}

resource "aws_iam_instance_profile" "nodes-kubetest1-k8s-local" {
  name = "nodes.${var.our_cluster}.k8s.local"
  role = "${aws_iam_role.nodes-kubetest1-k8s-local.name}"
}

resource "aws_iam_role" "our_masters" {
  name               = "masters.${var.our_cluster}.k8s.local"
  assume_role_policy = "${data.aws_iam_policy_document.masters_policy.json}"
}

data "aws_iam_policy_document" "masters_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "nodes-kubetest1-k8s-local" {
  name               = "nodes.${var.our_cluster}.k8s.local"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.kubetest1.k8s.local_policy")}"
}

resource "aws_iam_role_policy" "our_masters" {
  name   = "masters.${var.our_cluster}.k8s.local"
  role   = "${aws_iam_role.our_masters.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.kubetest1.k8s.local_policy")}"
}

resource "aws_iam_role_policy" "nodes-kubetest1-k8s-local" {
  name   = "nodes.${var.our_cluster}.k8s.local"
  role   = "${aws_iam_role.nodes-kubetest1-k8s-local.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.kubetest1.k8s.local_policy")}"
}

resource "aws_key_pair" "kubernetes-kubetest1-k8s-local-807fcea70888e1078222f4a4a76e3e3f" {
  key_name   = "kubernetes.kubetest1.k8s.local-80:7f:ce:a7:08:88:e1:07:82:22:f4:a4:a7:6e:3e:3f"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.kubetest1.k8s.local-807fcea70888e1078222f4a4a76e3e3f_public_key")}"
}

resource "aws_launch_configuration" "master-us-west-2a-masters-kubetest1-k8s-local" {
  name_prefix                 = "master-us-west-2a.masters.kubetest1.k8s.local-"
  image_id                    = "ami-f5d2548d"
  instance_type               = "m3.medium"
  key_name                    = "${aws_key_pair.kubernetes-kubetest1-k8s-local-807fcea70888e1078222f4a4a76e3e3f.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.our_masters.id}"
  security_groups             = ["${aws_security_group.our_masters.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-west-2a.masters.kubetest1.k8s.local_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "nodes-k8s" {
  name_prefix                 = "nodes.${var.our_cluster}.k8s.local-"
  image_id                    = "ami-f5d2548d"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-kubetest1-k8s-local-807fcea70888e1078222f4a4a76e3e3f.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-kubetest1-k8s-local.id}"
  security_groups             = ["${aws_security_group.nodes-kubetest1-k8s-local.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.kubetest1.k8s.local_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.kube_routes.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "igw-0bc9cb45cd7b7cf8f"
}

resource "aws_route_table" "kube_routes" {
  vpc_id = "${var.vpc_id}"

  tags = {
    KubernetesCluster = "${var.our_cluster}.k8s.local"
    Name              = "${var.our_cluster}.k8s.local"
  }
}

resource "aws_route_table_association" "kubenet_routes" {
  count = "${length(var.kubernetes_subnets) > 0 ? length(var.kubernetes_subnets) : 0}"
  subnet_id      = "${element(aws_subnet.kubenet.*.id, count.index)}"
  route_table_id = "${aws_route_table.kube_routes.id}"
}


resource "aws_security_group" "api-elb-kubetest1-k8s-local" {
  name        = "api-elb.${var.our_cluster}.k8s.local"
  vpc_id      = "${var.vpc_id}"
  description = "Security group for api ELB"

  tags = {
    KubernetesCluster = "${var.our_cluster}.k8s.local"
    Name              = "api-elb.${var.our_cluster}.k8s.local"
  }
}

resource "aws_security_group" "our_masters" {
  name        = "masters.${var.our_cluster}.k8s.local"
  vpc_id      = "${var.vpc_id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "${var.our_cluster}.k8s.local"
    Name              = "masters.${var.our_cluster}.k8s.local"
  }
}

resource "aws_security_group" "nodes-kubetest1-k8s-local" {
  name        = "nodes.${var.our_cluster}.k8s.local"
  vpc_id      = "${var.vpc_id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "${var.our_cluster}.k8s.local"
    Name              = "nodes.${var.our_cluster}.k8s.local"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.our_masters.id}"
  source_security_group_id = "${aws_security_group.our_masters.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-kubetest1-k8s-local.id}"
  source_security_group_id = "${aws_security_group.our_masters.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-kubetest1-k8s-local.id}"
  source_security_group_id = "${aws_security_group.nodes-kubetest1-k8s-local.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "api-elb-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.api-elb-kubetest1-k8s-local.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-api-elb-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.api-elb-kubetest1-k8s-local.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-elb-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.our_masters.id}"
  source_security_group_id = "${aws_security_group.api-elb-kubetest1-k8s-local.id}"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.our_masters.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-kubetest1-k8s-local.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.our_masters.id}"
  source_security_group_id = "${aws_security_group.nodes-kubetest1-k8s-local.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.our_masters.id}"
  source_security_group_id = "${aws_security_group.nodes-kubetest1-k8s-local.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.our_masters.id}"
  source_security_group_id = "${aws_security_group.nodes-kubetest1-k8s-local.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.our_masters.id}"
  source_security_group_id = "${aws_security_group.nodes-kubetest1-k8s-local.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.our_masters.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-kubetest1-k8s-local.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "kubenet" {
  count = "${length(var.kubernetes_subnets) > 0 ? length(var.kubernetes_subnets) : 0}"
  vpc_id            = "${var.vpc_id}"
  cidr_block              = "${var.kubernetes_subnets[count.index]}"
  availability_zone       = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = true

  tags = {
    KubernetesCluster                           = "${var.our_cluster}.k8s.local"
    Name                                        = "${element(var.azs, count.index)}.${var.our_cluster}.k8s.local"
    "kubernetes.io/cluster/${var.our_cluster}.k8s.local" = "owned"
    "kubernetes.io/role/elb"                    = "1"
  }
}


terraform = {
  required_version = ">= 0.9.3"
}
