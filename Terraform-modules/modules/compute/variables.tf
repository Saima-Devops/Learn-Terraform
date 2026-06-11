variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}
