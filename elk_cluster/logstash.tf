module "logstash_instance" {
  source = "../primitives/instance"
  name = "logstash"
  stack_name = "${var.name}"
  chef_environment = "${var.env}"
  subnet_id = "${var.subnets_id[0]}"
  security_groups = ["${aws_security_group.logstash.id}", "${aws_security_group.elk_cluster_default_sg.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.key_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[logstash2]"]
  private_key = "${var.private_key}"
  instance_type = "${var.logstash_instance_type}"
  instance_count = "${var.logstash_number_of_instances}"
  is_standard_instance = "false"
}