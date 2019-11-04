terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "${var.vpc_link_name}"
  description = "${var.vpc_link_name}"
  target_arns = ["${var.load_balancer_arn}"]
}