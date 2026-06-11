terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.16.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "Learn-Terraform-AWS"
      Topic       = "Type-Constraints"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}