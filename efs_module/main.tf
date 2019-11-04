terraform {
  backend "s3" {}
}

resource "aws_security_group" "efs" {
  name        = "${var.name}-efs-sg"
  description = "Allow NFS traffic."
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port   = "2049"
    to_port     = "2049"
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_cidr_blocks}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.name}-efs-sg"
    Terraform   = "true"
  }
}


resource "aws_efs_file_system" "efs" {
  creation_token   = "${var.name}"
  performance_mode = "${var.performance_mode}"
  encrypted        = "${var.encrypted}"
  tags = {
    Name = "${var.name}"
    Terraform   = "true"
  }
}


resource "aws_efs_mount_target" "efs" {
  count = "${length(var.subnets_ids)}"
  file_system_id  = "${aws_efs_file_system.efs.id}"
  subnet_id = "${element(var.subnets_ids, count.index)}"
  security_groups = ["${aws_security_group.efs.id}"]
}
