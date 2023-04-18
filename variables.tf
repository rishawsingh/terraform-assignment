variable "region" {
  type    = string
  default = "us-east-1"
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