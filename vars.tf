variable "element_vpc" {
  default = "Element VPC"
}

variable "region" {
  default = "eu-central-1"
}

variable "bucket_name" {
  default = "arturo-exchange"
}

variable "role_ec2" {
  default = "role_ec2"
}

variable "role_lambda" {
  default = "role_lambda"
}

variable "lambda_name" {
  default = "arturo-exchange"
}

variable "private_element_in_domain" {
  default = "private.element.in"
}
