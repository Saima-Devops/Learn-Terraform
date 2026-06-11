terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-saima"
    key    = "backup01/terraform.tfstate"
    region = "us-east-1"
  }
}

# The purpose of this s3 Bucket is to save the terraform state file as a backup.
# This s3 Bucket should be already present on AWS before applying terraform.
