terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_availability_zones" "available" {}

resource "aws_vpc" "demo" {
  # cidr_block = "10.0.0.0/16"
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = true

  tags = "${
    map(
     "Name", "${var.cluster-name}",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "demo" {
  # count = 2
  count = "${length(var.subnets) > 0 ? length(var.subnets) : 0}"
  #availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  # availability_zone = "${var.zones[count.index]}"
  availability_zone = "${element(var.zones, count.index)}"
  # cidr_block        = "10.0.${count.index}.0/24"
  cidr_block        = "${element(var.subnets, count.index)}"
  vpc_id            = "${aws_vpc.demo.id}"

  tags = "${
    map(
     "Name", "${var.cluster-name}",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "demo" {
  vpc_id = "${aws_vpc.demo.id}"

  tags = {
    Name = "${var.cluster-name}"
  }
}

resource "aws_route_table" "demo" {
  vpc_id = "${aws_vpc.demo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo.id}"
  }
}

resource "aws_route_table_association" "demo" {
  count = "${length(var.subnets) > 0 ? length(var.subnets) : 0}"

  subnet_id      = "${aws_subnet.demo.*.id[count.index]}"
  route_table_id = "${aws_route_table.demo.id}"
}
