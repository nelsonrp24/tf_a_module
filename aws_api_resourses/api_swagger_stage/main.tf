terraform {
  backend "s3" {}
}


data "aws_api_gateway_rest_api" "rest_api" {
  name = "${var.api_name}"
}

resource "aws_api_gateway_vpc_link" "rest_api_staging" {
  name        = "${var.api_name}-${var.stage_name}"
  description = "${var.api_name}-${var.stage_name}"
  target_arns = ["${var.load_balancer_arn}"]
}

resource "aws_api_gateway_stage" "rest_api" {
  stage_name    = "${var.stage_name}"
  rest_api_id   = "${data.aws_api_gateway_rest_api.rest_api.id}"
  deployment_id = "${aws_api_gateway_deployment.rest_api.id}"
  xray_tracing_enabled = true
  variables = {
    endpointHost = "${var.api_name}"
    vpcLinkId = "${aws_api_gateway_vpc_link.rest_api_staging.id}"
  }
}


resource "aws_api_gateway_deployment" "rest_api" {
  rest_api_id = "${data.aws_api_gateway_rest_api.rest_api.id}"  
}