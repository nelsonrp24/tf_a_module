variable "username" {
  type = "string"
  description = "The IAM user to manage"
}

variable "keybase_username" {
  type = "string"
  description = "the keybase id to encrypt all secrets against"
}

variable "ssh_public_key" {
  type = "string"
  description = "passed as the public_key parameter to the aws_key_pair resource"
}

variable "manage_aws_key_pair" {
  type = "string"
  default = "true"
  description = "should we attempt to upload/manage an ssh key"
}
