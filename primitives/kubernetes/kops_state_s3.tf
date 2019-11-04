# makes an s3 bucket to store the kops state
# from https://github.com/kubernetes/kops/blob/master/docs/aws.md

# like
# aws s3api create-bucket \
# --bucket prefix-example-com-state-store \
# --region us-east-1
# and enabling versioning
# aws s3api put-bucket-versioning --bucket prefix-example-com-state-store  --versioning-configuration Status=Enabled

resource "aws_s3_bucket" "kops_state_bucket" {
  bucket = "${var.cluster_name}-${replace(var.domain_name,".","-")}-kops-state-store"
  acl    = "private"
  region = "us-east-1"

  tags {
    Name        = "kops state store for ${var.cluster_name}"
    Terraformed = "true"
  }

  versioning {
    enabled = true
  }

  // when we get a logging bucket set we should go ahead and log accesses to the state
//  logging {
//    target_bucket = "${aws_s3_bucket.log_bucket.id}"
//    target_prefix = "log/"
//  }

  # should encrypt with per-client kms as well

}
