variable "aws_access_key" {
  type = "string"
}
variable "aws_secret_key" {
  type = "string"
}
variable "cloudflare_api_key" {
  type = "string"
}
variable "mysql_password" {
  type = "string"
}
variable "cloudflare_email" {
  type = "string"
}
variable "ami" {
  type    = "string"
  default = "ami-e59ae09d"
}
variable "cloudflare_website" {
  type = "string"
}
variable "docker_version" {
  type    = "string"
  default = "17.03.2-ce"
}
variable "letsencrypt_email" {
  type    = "string"
}
variable "mysql_database" {
  type    = "string"
}
variable "mysql_hostname" {
  type    = "string"
}
variable "mysql_user" {
  type    = "string"
}
variable "region" {
  type    = "string"
  default = "us-west-2"
}
variable "instance_type" {
  type    = "string"
  default = "t2.medium"
}
variable "rancher_hostname" {
  type = "string"
}
variable "volume_size" {
  type    = "string"
  default = "8"
}
