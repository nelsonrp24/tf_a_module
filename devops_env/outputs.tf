output "instance_name" {
  value = "${var.name}"
}

output "jenkins_public_ip" {
  description = "Public IP of the Jenkins server"
  value = "${module.devops_jenkins.public_ip}"
}