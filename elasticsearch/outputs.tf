output "domain_name" {
  value = "${aws_elasticsearch_domain.es.domain_name}"
}

output "arn" {
  value = "${aws_elasticsearch_domain.es.arn}"
}

output "endpoint" {
    value = "${aws_elasticsearch_domain.es.endpoint}"
}

output "kibana_endpoint" {
    value = "${aws_elasticsearch_domain.es.kibana_endpoint}"
}

output "volume size"{
    value = "${var.es_ebs_voulume_size}"
}

output "instance_type" {
    value = "${var.es_instance_type}"
}

output "instance_count" {
    value = "${var.es_instance_count}"
}