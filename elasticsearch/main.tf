terraform {
  backend "s3" {}
}

provider "aws" {
 region  = "${var.region}"
 version = "~> 1.7"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = "${var.es_domain}"
  elasticsearch_version = "${var.es_version}"

  cluster_config {
    instance_type = "${var.es_instance_type}"
    instance_count = "${var.es_instance_count}"
    zone_awareness_enabled = "${var.es_zone_awareness_enabled}"
  }

  ebs_options {
      ebs_enabled = "true"
      volume_size = "${var.es_ebs_voulume_size}"
      volume_type = "gp2"
  }

  advanced_options {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = <<CONFIG
  {
      "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "*"
        ]
      },
      "Action": [
        "es:*"
      ],
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain}/*"
    }
  ]
  }
  CONFIG

  tags {
    Domain = "${var.es_domain}"
    Name = "${var.es_tag_name}"
  }
    
}

