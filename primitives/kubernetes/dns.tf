//resource "aws_route53_zone" "main" {
//  name = "${var.domain_name}"
//}
//
//resource "aws_route53_zone" "cluster" {
//  name = "${var.cluster_name}.${var.domain_name}"
//
//  tags {
//    Cluster = "${var.cluster_name}"
//    Terraformed = "true"
//  }
//}
//
//resource "aws_route53_record" "dev-ns" {
//  zone_id = "${aws_route53_zone.main.zone_id}"
//  name    = "${var.cluster_name}.${var.domain_name}"
//  type    = "NS"
//  ttl     = "300"
//
//  records = [
//    "${aws_route53_zone.cluster.name_servers.0}",
//    "${aws_route53_zone.cluster.name_servers.1}",
//    "${aws_route53_zone.cluster.name_servers.2}",
//    "${aws_route53_zone.cluster.name_servers.3}",
//  ]
//}
