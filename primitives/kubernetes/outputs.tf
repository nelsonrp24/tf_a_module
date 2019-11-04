output "cluster_name" {
  value = "${var.our_cluster}.k8s.local"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.our_masters.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.our_masters.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.our_masters.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-kubetest1-k8s-local.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.kubenet.*.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-kubetest1-k8s-local.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-kubetest1-k8s-local.name}"
}

output "region" {
  value = "us-west-2"
}

output "vpc_id" {
  value = "${var.vpc_id}"
}
