# Use this to bootstrap a new person into the AWS account

# This implements an IAM user via a pattern similar to the best practices outlined here: https://github.com/terraform-aws-modules/terraform-aws-iam

terraform {
  backend "s3" {}
}

module "iam_user" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name          = "${var.username}"
  force_destroy = true

  pgp_key = "keybase:${var.keybase_username}"

  password_reset_required = false
}

resource "aws_key_pair" "imported" {
  count = "${var.manage_aws_key_pair == "true" ? 1 : 0}"
  key_name = "${var.username}"
  public_key = "${var.ssh_public_key}"
}
