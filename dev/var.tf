variable "use_region" {
  default = "ap-northeast-2"
}

variable "project_env" {
  default = "dev"
}
variable "eksinstance" {
  default = "t3.small"
}

variable "ourdomain" {}
variable "ovpnpw" {}
variable "ovpnuser" {}
variable "mqpw" {}
variable "mquser" {}
variable "dbpw" {}
variable "dbuser" {}
variable "keypair" {}
variable "oidcclient" {}
variable "route53zoneid" {}