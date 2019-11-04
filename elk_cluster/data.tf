data "aws_ami" "ami_type" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_os_name_filter_by_value}"]
  }

  owners = ["679593333241","self"]
}