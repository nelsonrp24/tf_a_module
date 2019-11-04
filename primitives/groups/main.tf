# manage the mappings of users to these groups (admin, developer, readonly) via the tf_live

terraform {
  backend "s3" {}
}

module "iam_groups" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  trusted_role_arns = ["${var.trusted_role_arns}"]

  create_admin_role = true
  admin_role_requires_mfa = false

  create_poweruser_role = true
  poweruser_role_name   = "developer"

  create_readonly_role       = true
  readonly_role_requires_mfa = false
}
