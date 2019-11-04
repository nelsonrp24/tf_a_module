terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_vpc_peering_connection" "this" {
  peer_vpc_id   = "${var.vpc_accepter_id}"
  vpc_id        = "${var.vpc_requester_id}"
  auto_accept   = true
}


resource "aws_route" "accepter_route_table" {
  count = "${length(var.accepter_route_table_ids)}"

  route_table_id            = "${element(var.accepter_route_table_ids, count.index)}"
  destination_cidr_block    = "${var.requester_cird_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.this.id}"
  depends_on                = ["aws_vpc_peering_connection.this"]
}

resource "aws_route" "requester_route_table" {
  count = "${length(var.requester_route_table_ids)}"

  route_table_id            = "${element(var.requester_route_table_ids, count.index)}"
  destination_cidr_block    = "${var.accepter_cird_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.this.id}"
  depends_on                = ["aws_vpc_peering_connection.this"]
}
