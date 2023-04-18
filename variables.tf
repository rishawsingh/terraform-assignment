variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "ami" {
  type    = string
  default = "ami-0aef57767f5404a35"
}

variable "name" {
  type    = string
  default = "wordpress_db"
}

variable "username" {
  type    = string
  default = "db_user"
}

variable "password" {
  type    = string
  default = "db_password"
}
