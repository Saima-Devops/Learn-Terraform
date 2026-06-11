variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "bucket_prefix" {
  type    = string
  default = "app-bucket"
}
