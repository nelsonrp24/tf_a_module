# shims, since most VPC work is done in the saas_vpc module and what we need is passed into this

resource "aws_route53_zone" "vpc_internal_zone" {
  name          = "local.vpc"
  comment       = "Internal zone"
  vpc_id        = "${var.vpc_id}"
  force_destroy = true
}

resource "aws_route53_zone" "k8s_zone" {
  name          = "k8s.${var.domain_name}"
  vpc_id        = "${var.vpc_id}"
  force_destroy = true
}

//resource "aws_subnet" "public" {
//  count                   = "${length(var.azs)}"
//  vpc_id                  = "${var.vpc_id}"
//  cidr_block              = "${element(var.kubernetes_subnets, count.index)}"
//  availability_zone       = "${element(var.azs, count.index)}"
//  map_public_ip_on_launch = true
//
//  tags {
//    "Name" = "public ${element(var.azs, count.index)}"
//  }
//}
//
//resource "aws_route_table_association" "public" {
//  count          = "${length(var.azs)}"
//  route_table_id = "${var.route_table_id}"
//  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
//}

# VPC resources related to private subnets with NAT gateways

//resource "aws_subnet" "nat_private" {
//  count                   = "${length(data.aws_availability_zones.available.names)}"
//  vpc_id                  = "${aws_vpc.main_vpc.id}"
//  cidr_block              = "${element(local.nat_private_cidr_blocks, count.index)}"
//  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
//  map_public_ip_on_launch = false
//
//  tags {
//    "Name" = "NAT private ${element(data.aws_availability_zones.available.names, count.index)}"
//  }
//}
//
//resource "aws_route_table" "nat_private" {
//  count  = "${length(data.aws_availability_zones.available.names)}"
//  vpc_id = "${aws_vpc.main_vpc.id}"
//
//  route {
//    cidr_block     = "0.0.0.0/0"
//    nat_gateway_id = "${element(aws_nat_gateway.nat_gateway.*.id, count.index)}"
//  }
//
//  tags {
//    "Name" = "NAT private ${element(data.aws_availability_zones.available.names, count.index)}"
//  }
//}
