# terraform {
#   backend "s3" {}
# }

resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "${var.api_name}"
  description = "This is my API for ${var.api_name}"
  body        = "${data.template_file.api_swagger.rendered}"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_vpc_link" "rest_api_staging" {
  name        = "${var.vpc_link_name}"
  description = "${var.vpc_link_name}"
  target_arns = ["${var.load_balancer_arn}"]
}

data "template_file" api_swagger{
  template = "${file(var.absolute_path_file)}"
}

resource "aws_api_gateway_stage" "rest_api" {
  stage_name    = "${var.stage_name}"
  rest_api_id   = "${aws_api_gateway_rest_api.rest_api.id}"
  deployment_id = "${aws_api_gateway_deployment.rest_api.id}"
  xray_tracing_enabled = true
  variables = {
    endpointHost = "${var.endpointHost}"
    vpcLinkId = "${aws_api_gateway_vpc_link.rest_api_staging.id}"
  }
}


resource "aws_api_gateway_deployment" "rest_api" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"  
  depends_on = ["aws_api_gateway_rest_api.rest_api"]
}