# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  # Configuration options
    region = "us-east-1"
}

# backend configuration
terraform {
  backend "s3" {
    bucket         = "terraform-state-1780863891"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile  = "true"
    encrypt        = true
  }
}


# Simple test resource to verify remote backend
resource "aws_s3_bucket" "test_backend" {
  bucket = "test-remote-backend-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "Test Backend Bucket"
    Environment = "dev"
  }
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}