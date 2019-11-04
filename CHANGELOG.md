tf_module changes
---

If you update tf_modules, update the `VERSION` file in the root of the repo and detail your changes in this file.

0.0.3

* VPC now tagged with a Tf_modules_version from `VERSION`
* k8s cluster now managed via a `cluster_spec.yaml` template
* docker in k8s node/master now logging to CloudWatch
* a single demo chef instance


0.0.2

k8s cluster now spawns a master in each AZ and starts with three node boxes
kops_k8s_cluster now refers to a forked copy in `github.com/FastRobot/tf-kops-cluster`
