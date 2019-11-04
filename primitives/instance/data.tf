data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    #values = ["CentOS-7*"]
    values = ["${var.ami_os_name_filter_by_value}"]
  }

  owners = ["679593333241","self"]
}