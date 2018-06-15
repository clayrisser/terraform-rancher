variable "aws_access_key" {
  type = "string"
}
variable "aws_secret_key" {
  type = "string"
}
variable "cloudflare_api_key" {
  type = "string"
}
variable "rancher_register_url" {
  type = "string"
}
variable "cloudflare_website" {
  type = "string"
}
variable "cloudflare_email" {
  type    = "string"
}
variable "region" {
  type    = "string"
  default = "us-west-2"
}
variable "rancher_agent_version" {
  type    = "string"
  default = "1.2.10"
}
variable "docker_version" {
  type    = "string"
  default = "17.03.2-ce"
}
variable "ami" {
  type    = "string"
  default = "ami-e59ae09d"
}
variable "instance_type" {
  type    = "string"
  default = "t2.medium"
}
variable "volume_size" {
  type    = "string"
  default = "20"
}
variable "desired_capacity" {
  type    = "string"
}
