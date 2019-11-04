terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = "${var.api_id}"
  path   = "${var.path}"
}


resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = "${var.api_id}"
  parent_id   = "${var.api_root_resource_id}"
  path_part   = "${var.resource_path}"
}

