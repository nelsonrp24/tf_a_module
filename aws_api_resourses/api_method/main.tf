terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = "${var.api_id}"
  resource_id   = "${var.resource_id}"
  http_method   = "${var.method}"
  authorization = "NONE"
}