output "id" {
  value = "${aws_s3_bucket.s3_bucket.id}"
}

output "name" {
  value = "${var.s3_bucket_name}"
}

output "arn" {
  value = "${aws_s3_bucket.s3_bucket.arn}"
}