# I expect this to be a module which we use to create every type of instance. One place to customize the various
# chef, profile, etc.

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_instance" "this_instance" {
  count = "${var.is_standard_instance == "true" ? 0 : var.instance_count}"
  
  ami = "${data.aws_ami.centos.id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = "${var.security_groups}"
  associate_public_ip_address = "${var.associate_public_ip}"

  connection {
    host = "${self.public_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file(var.private_key)}"
  }

  tags = {
    Name = "${var.stack_name}-${var.name}"
  }

   root_block_device {
    volume_size = "${var.root_volume_size}"
    volume_type = "gp2"
    delete_on_termination = true
  }

  provisioner "remote-exec" {
      inline = [
        "sudo yum -y install cloud-utils-growpart",
        "sudo growpart /dev/xvda 2",
        "sudo pvresize /dev/xvda2",
        "sudo vgextend centos /dev/xvda2",
        "sudo lvextend -l +${var.usr_partition_percentage}%FREE /dev/mapper/centos-usr",
        "sudo lvextend -l +${var.var_partition_percentage}%FREE /dev/mapper/centos-var",
        "sudo xfs_growfs /dev/mapper/centos-usr",
        "sudo xfs_growfs /dev/mapper/centos-var"
      ]
    }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's/127.0.0.1 localhost/127.0.0.1 ${var.stack_name}-${var.name}-${self.id} localhost/' /etc/hosts",
      "echo ${var.stack_name}-${var.name}-${self.id} | sudo tee /etc/hostname",
      "sudo /sbin/shutdown -r +1"
    ]
  }

  provisioner "local-exec" {
    command = "sleep 90"
  }


  provisioner "chef"  {
    connection {
        host = "${self.public_ip}"
        type = "ssh"
        user = "centos"
        private_key = "${file(var.private_key)}"
    }
    environment = "${var.chef_environment}"
    run_list = "${var.run_list}"
    node_name  = "${var.stack_name}-${var.name}-${self.id}"
    server_url = "${var.chef_server_url}"
    recreate_client = true
    user_name = "${var.chef_user}"
    user_key = "${file(var.chef_pem)}"
    fetch_chef_certificates = true
    version         = "${var.chef_version}"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "knife node delete ${var.stack_name}-${var.name}-${self.id} -y; knife client delete ${var.stack_name}-${var.name}-${self.id} -y"
  }
}

resource "aws_instance" "standard_instance" {
  count = "${var.is_standard_instance == "true" ? var.instance_count : 0}"
  
  ami = "${data.aws_ami.centos.id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = "${var.security_groups}"
  associate_public_ip_address = "${var.associate_public_ip}"

  connection {
    host = "${self.public_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file(var.private_key)}"
  }

  tags = {
    Name = "${var.stack_name}-${var.name}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's/127.0.0.1 localhost/127.0.0.1 ${var.stack_name}-${var.name}-${self.id} localhost/' /etc/hosts",
      "echo ${var.stack_name}-${var.name}-${self.id} | sudo tee /etc/hostname",
      "sudo /sbin/shutdown -r +1"
    ]
  }

  provisioner "local-exec" {
    command = "sleep 90"
  }


  provisioner "chef"  {
    connection {
        host = "${self.public_ip}"
        type = "ssh"
        user = "centos"
        private_key = "${file(var.private_key)}"
    }
    environment = "${var.chef_environment}"
    run_list = "${var.run_list}"
    node_name  = "${var.stack_name}-${var.name}-${self.id}"
    server_url = "${var.chef_server_url}"
    recreate_client = true
    user_name = "${var.chef_user}"
    user_key = "${file(var.chef_pem)}"
    fetch_chef_certificates = true
    version         = "${var.chef_version}"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "knife node delete ${var.stack_name}-${var.name}-${self.id} -y; knife client delete ${var.stack_name}-${var.name}-${self.id} -y"
  }
}

resource "aws_eip" "eip_custom" {
  count    = "${var.is_standard_instance == "true" ? 0 : var.eip_count}"
  instance = "${aws_instance.this_instance[count.index].id}"
  vpc = "true"
  
}

resource "aws_eip" "eip_standard" {
  instance = "${aws_instance.standard_instance[count.index].id}"
  vpc = "true"
  count    = "${var.is_standard_instance == "true" ? var.eip_count : 0}"
}

