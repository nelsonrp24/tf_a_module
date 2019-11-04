terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_elasticsearch_domain" "elastic" {
  domain_name           = "${var.domain_name}"
  elasticsearch_version = "${var.elasticsearch_version}"
  ebs_options {
    ebs_enabled = true
    volume_type = "${var.volume_type}"
    volume_size = "${var.volume_size}"  
  }

  cluster_config {
    instance_type = "${var.instance_type}"
    instance_count = "${var.instance_count}"
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = {
    Domain = "${var.domain_name}"
  }

  access_policies = "${var.access_policies}"
}