output "kops_bucket_name" {
  value = "${aws_s3_bucket.kops.bucket}"
}

output "cluster_api" {
  value = "${module.public_k8s_cluster.master_elb_dns_name}"
}
