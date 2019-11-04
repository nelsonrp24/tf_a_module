output "public_ip" {
  value = "${aws_instance.this_instance.*.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.this_instance.*.private_ip}"
}

output "id" {
  value = "${aws_instance.this_instance.*.id}"
}