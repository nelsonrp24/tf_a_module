terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.api_name}"
  description = "This is my API for ${var.api_name}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}