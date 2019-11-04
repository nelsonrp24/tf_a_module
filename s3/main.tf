terraform {
  backend "s3" {}
}

provider "aws" {
 region  = "${var.region}"
 # version = "~> 1.7"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.s3_bucket_name}"
  acl    = "private"
  tags = {
    Name        = "${var.s3_bucket_tag}"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_policy" {
  bucket = "${aws_s3_bucket.s3_bucket.id}"

  block_public_acls   = true
  block_public_policy = true
}