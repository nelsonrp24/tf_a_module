data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.demo.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon Account ID
}

# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_region" "current" {}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  demo-node-userdata = <<USERDATA
#!/bin/bash
  set -o xtrace
  /etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.demo.endpoint}' --b64-cluster-ca '${aws_eks_cluster.demo.certificate_authority.0.data}' '${var.cluster-name}' --kubelet-extra-args '--kube-reserved cpu=1,memory=2Gi,ephemeral-storage=1Gi --system-reserved cpu=500m,memory=1Gi,ephemeral-storage=1Gi --eviction-hard memory.available<500Mi,nodefs.available<10%'
USERDATA
}

resource "aws_launch_configuration" "demo" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.demo-node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "${var.instance_type}"
  name_prefix                 = "${var.cluster-name}"
  security_groups             = ["${aws_security_group.demo-node.id}"]
  user_data_base64            = "${base64encode(local.demo-node-userdata)}"
  key_name      = "${var.keypair}"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.worker_disk_size}"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo" {
  desired_capacity     = 3
  launch_configuration = "${aws_launch_configuration.demo.id}"
  max_size             = 5
  min_size             = 1
  name                 = "${var.cluster-name}"
  vpc_zone_identifier  = "${aws_subnet.demo.*.id}"

  tag {
    key                 = "Name"
    value               = "${var.cluster-name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}