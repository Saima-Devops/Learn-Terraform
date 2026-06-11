variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "ami_id" {
  type        = string
  default     = ""
  description = "AMI ID for EC2 instances (set in terraform.tfvars)"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_bucket_prefix" {
  type    = string
  default = "tf-aws-webserver-app"
}
