data "aws_caller_identity" "current" {}

data "terraform_remote_state" "our_admin" {
  backend = "s3"
  config {
    bucket         = "${var.tfstate_global_bucket}"
    key            = "${var.terragrunt_remote_admin_state_key}"
    region         = "${var.tfstate_global_bucket_region}"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}


//data "aws_vpc" "our_admin" {
//  id = "${var.admin_vpc_id}"
//}

//data "aws_subnet_ids" "our_admin_subnets" {
//  vpc_id = "${var.admin_vpc_id}"
//}
//
//data "aws_subnet" "an_admin_subnet" {
//  count = "${length(data.aws_subnet_ids.our_admin_subnets.ids)}"
//  id = "${data.aws_subnet_ids.our_admin_subnets.ids[count.index]}"
//}

//data "aws_route_table" "our_admin_route_tables" {
//  vpc_id = "${var.admin_vpc_id}"
//}

//data "aws_route_table" "our_admin_public_route_table" {
//  vpc_id = "${var.admin_vpc_id}"
//  tags {
//    Name = "admin-dev-public"
//  }
//
//}

//data "aws_route_table" "our_admin_private_route_table" {
//  vpc_id = "${var.admin_vpc_id}"
//  tags {
//    Name = "admin-dev-private"
//  }
//}
