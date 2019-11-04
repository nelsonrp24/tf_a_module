
module "kibana_instance" {
  source = "../primitives/instance"
  name = "kibana"
  stack_name = "${var.name}"
  chef_environment = "${var.env}"
  subnet_id = "${var.subnets_id[0]}"
  security_groups = ["${aws_security_group.kibana.id}", "${aws_security_group.elk_cluster_default_sg.id}"]
  chef_user = "${var.chef_user}"
  chef_pem = "${var.chef_user_key}"
  key_name = "${var.key_name}"
  chef_server_url = "${var.chef_server_url}"
  associate_public_ip = "true"
  run_list = ["role[kibana2]"]
  private_key = "${var.private_key}"
  instance_type = "${var.kibana_instance_type}"
  instance_count = "${var.kibana_number_of_instances}"
  is_standard_instance = "false"
}

terraform {
  backend "s3" {}
}

module "kibana_elb" {
  source = "terraform-aws-modules/elb/aws"
  name = "kibana-elb"
  subnets         = ["${var.subnets_id}"]
  security_groups = ["${aws_security_group.kibana.id}", "${aws_security_group.elk_cluster_default_sg.id}"]
  internal        = false

listener = [
  {
    instance_port     = "80"
    instance_protocol = "HTTP"
    lb_port           = "80"
    lb_protocol       = "HTTP"
  },
  {
  instance_port     = "443"
  instance_protocol = "HTTP"
  lb_port           = "443"
  lb_protocol       = "HTTP"
  },
    {
  instance_port     = "5601"
  instance_protocol = "HTTP"
  lb_port           = "5601"
  lb_protocol       = "HTTP"
  },
]

health_check = [
  {
    target              = "HTTP:5601/app/kibana#/home?_g=()"
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 6
    timeout             = 5
  }
]
  number_of_instances = "${var.kibana_number_of_instances}"
  instances           = ["${module.kibana_instance.id}"]

  tags = {
    Name = "kibana_elb-${var.name}"
  }
}


