terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_api_gateway_integration" "api_metho_setting" {
  rest_api_id = "${var.api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"

  # request_templates = {
  #   "application/json" = ""
  #   "application/xml"  = "#set($inputRoot = $input.path('$'))\n{ }"
  # }

  # request_parameters = {
  #   "integration.request.header.X-Authorization" = "'static'"
  #   "integration.request.header.X-Foo"           = "'Bar'"
  # }

  type                    = "${var.type}"
  uri                     = "${var.uri}"
  integration_http_method = "${var.http_method}"


  connection_type = "VPC_LINK"
  connection_id   = "${var.vpc_link_id}"
}