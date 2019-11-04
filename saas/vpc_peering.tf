
# this sets up a bi-directional peering point between the admin vpc, identified by the admin_vpc_id variable, and this saas vpc
resource "aws_vpc_peering_connection" "admin2saas" {
  peer_owner_id = "${data.aws_caller_identity.current.account_id}"
  auto_accept = true
  peer_vpc_id = "${module.saas_vpc.vpc_id}"
  vpc_id = "${data.terraform_remote_state.our_admin.vpc_id}"
  tags {
    Name = "${data.terraform_remote_state.our_admin.name}-to-${var.name}"
  }
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

# using the admin_vpc_id and the data.aws_vpc lookup in data.tf, establish routes from that admin vpc to our saas vpc cidr
resource "aws_route" "admin_public2saas" {
  count = "${length(data.terraform_remote_state.our_admin.public_route_table_ids)}"
  route_table_id = "${element(data.terraform_remote_state.our_admin.public_route_table_ids, count.index)}"
  destination_cidr_block = "${module.saas_vpc.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.admin2saas.id}"
}

resource "aws_route" "saas_public2admin" {
  count = "${length(module.saas_vpc.public_route_table_ids)}"
  route_table_id = "${element(module.saas_vpc.public_route_table_ids, count.index)}"
  destination_cidr_block = "${data.terraform_remote_state.our_admin.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.admin2saas.id}"
}

resource "aws_route" "saas_private2admin" {
  count = "${length(module.saas_vpc.private_route_table_ids)}"
  route_table_id = "${element(module.saas_vpc.private_route_table_ids, count.index)}"
  destination_cidr_block = "${data.terraform_remote_state.our_admin.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.admin2saas.id}"
}
