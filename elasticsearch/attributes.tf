variable "region" {}
#Domain name should be all lowercase. Valid characters are a-z, 0-9 and dashes
variable "es_domain" {}
variable "es_version" {
    default = "6.3"
}
variable "es_instance_type"{
    default = "m4.large.elasticsearch"
}
variable "es_instance_count"{
    default = "1"
}
# If this flag is enabled, then count should be 1.
variable "es_zone_awareness_enabled" {
    default = "false"
}
variable "es_ebs_voulume_size" {
    default = "10"
}
variable "es_tag_name" {}