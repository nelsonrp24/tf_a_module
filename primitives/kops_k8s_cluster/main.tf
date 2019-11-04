# A public k8s cluster

module "public_k8s_cluster" {
  #source                    = "github.com/FutureSharks/tf-kops-cluster/module"
  source                    = "github.com/FastRobot/tf-kops-cluster/module"
  #source = "../../tf-kops-cluster/module"
  kubernetes_version        = "1.8.7"
  sg_allow_ssh              = "${aws_security_group.allow_ssh.id}"
  sg_allow_http_s           = "${aws_security_group.allow_http.id}"
  cluster_name              = "${var.cluster_name}"
  cluster_fqdn              = "${var.cluster_name}.k8s.local"
  route53_zone_id           = "${aws_route53_zone.k8s_zone.id}"
  kops_s3_bucket_arn        = "${aws_s3_bucket.kops.arn}"
  kops_s3_bucket_id         = "${aws_s3_bucket.kops.id}"
  vpc_id                    = "${var.vpc_id}"
  cidr = "${var.cidr}"
  instance_key_name         = "${var.aws_key_pair_name}"
  node_asg_desired          = 3
  node_asg_min              = 3
  node_asg_max              = 9
  force_single_master       = false
  master_instance_type      = "t2.small"
  node_instance_type        = "t2.medium"
  internet_gateway_id       = "${var.igw_id}"
  public_subnet_cidr_blocks = "${var.kubernetes_subnets}"
  kops_dns_mode             = "private"
  ssh_public_key_path       = "${var.ssh_public_key_path}"
}

resource "random_id" "s3_suffix" {
  byte_length = 3
}

resource "aws_s3_bucket" "kops" {
  bucket        = "kops-state-store-${random_id.s3_suffix.dec}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}
