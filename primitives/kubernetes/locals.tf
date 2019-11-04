# https://www.terraform.io/docs/configuration/locals.html
# https://github.com/hashicorp/terraform/issues/2283

locals {
  common_tags = "${map(
    "KubernetesCluster", "${var.our_cluster}",
    "kubernetes.io/cluster/${var.our_cluster}", "${var.our_cluster}"
  )}"
}
