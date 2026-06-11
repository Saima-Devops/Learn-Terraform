variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "bucket_name" {
  type        = string
  description = "Name for the S3 bucket to store Terraform state (must be globally unique)"
}

variable "lock_table_name" {
  type        = string
  default     = "tf-state-lock"
  description = "DynamoDB table name for state locking"
}
