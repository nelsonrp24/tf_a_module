## Kubernetes creation from kops suggestions

This implements the kops/terraform suggestions:
https://github.com/kubernetes/kops/blob/master/docs/terraform.md

Expects:

* a domain name (fastrobot.com)
* a cluster name (saas-kube) 

Would create a cluster named saas

* a route53 controlled subdomain to create and operate in
  * currently manual intervention is needed to map the NS records for the subdomain to something route53 controls 
* a s3 bucket for kops to manage state
