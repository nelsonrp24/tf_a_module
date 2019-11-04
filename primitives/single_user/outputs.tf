output "this_iam_user_name" {
  description = "The user's name"
  value       = "${module.iam_user.this_iam_user_name}"
}

output "this_iam_access_key_id" {
  description = "The access key ID"
  value       = "${module.iam_user.this_iam_access_key_id}"
}

output "this_iam_access_key_key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the secret"
  value       = "${module.iam_user.this_iam_access_key_key_fingerprint}"
}

output "this_iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = "${module.iam_user.this_iam_user_arn}"
}