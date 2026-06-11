#!/bin/bash

# Create base directory
mkdir -p /Users/saimausman/Documents/Learn-Terraform/Terraform-modules

# Create subdirectories
mkdir -p /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/backend-bootstrap
mkdir -p /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/network
mkdir -p /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/security
mkdir -p /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/compute
mkdir -p /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/storage

# backend-bootstrap/main.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/backend-bootstrap/main.tf << 'EOF'
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_dynamodb_table" "state_lock" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
EOF

# backend-bootstrap/variables.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/backend-bootstrap/variables.tf << 'EOF'
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
EOF

# backend-bootstrap/outputs.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/backend-bootstrap/outputs.tf << 'EOF'
output "bucket_name" {
  value = aws_s3_bucket.tf_state.id
}

output "lock_table" {
  value = aws_dynamodb_table.state_lock.name
}
EOF

# Root backend.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/backend.tf << 'EOF'
terraform {
  backend "s3" {
    bucket         = "REPLACE_WITH_BOOTSTRAP_BUCKET"
    key            = "terraform-aws-webserver/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "REPLACE_WITH_DYNAMODB_TABLE"
  }
}
EOF

# Root provider.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/provider.tf << 'EOF'
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = var.environment
      Project     = "Terraform-aws-Webserver"
    }
  }
}
EOF

# Root variables.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/variables.tf << 'EOF'
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
EOF

# Root main.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/main.tf << 'EOF'
module "network" {
  source      = "./modules/network"
  region      = var.region
  environment = var.environment
  vpc_cidr    = "10.0.0.0/16"
}

module "security" {
  source      = "./modules/security"
  vpc_id      = module.network.vpc_id
  environment = var.environment
}

module "compute" {
  source             = "./modules/compute"
  region             = var.region
  environment        = var.environment
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  instance_count     = var.instance_count
  subnet_id          = element(module.network.public_subnet_ids, 0)
  security_group_ids = [module.security.web_sg_id]
}

module "storage" {
  source        = "./modules/storage"
  region        = var.region
  environment   = var.environment
  bucket_prefix = var.app_bucket_prefix
}
EOF

# Root outputs.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/outputs.tf << 'EOF'
output "vpc_id" {
  description = "VPC id created by the network module"
  value       = module.network.vpc_id
}

output "public_subnets" {
  description = "Public subnet ids"
  value       = module.network.public_subnet_ids
}

output "security_group_id" {
  description = "Web security group id"
  value       = module.security.web_sg_id
}

output "instance_ids" {
  description = "EC2 instance ids"
  value       = module.compute.instance_ids
}

output "instance_public_ips" {
  description = "Public IPs of EC2 instances"
  value       = module.compute.instance_public_ips
}

output "app_bucket_name" {
  description = "Application S3 bucket created by storage module"
  value       = module.storage.bucket_name
}
EOF

# modules/network/main.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/network/main.tf << 'EOF'
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.environment}-public-${count.index}"
    Environment = var.environment
  }
}
EOF

# modules/network/variables.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/network/variables.tf << 'EOF'
variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
EOF

# modules/network/outputs.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/network/outputs.tf << 'EOF'
output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
EOF

# modules/security/main.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/security/main.tf << 'EOF'
resource "aws_security_group" "web" {
  name   = "${var.environment}-web-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-web-sg"
    Environment = var.environment
  }
}
EOF

# modules/security/variables.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/security/variables.tf << 'EOF'
variable "vpc_id" {
  type = string
}

variable "environment" {
  type = string
}
EOF

# modules/security/outputs.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/security/outputs.tf << 'EOF'
output "web_sg_id" {
  value = aws_security_group.web.id
}
EOF

# modules/compute/main.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/compute/main.tf << 'EOF'
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name        = "${var.environment}-web-${count.index}"
    Environment = var.environment
  }

  root_block_device {
    volume_size = 8
    delete_on_termination = true
  }
}
EOF

# modules/compute/variables.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/compute/variables.tf << 'EOF'
variable "region" {
  type = string
}

variable "environment" {
  type = string
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
EOF

# modules/compute/outputs.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/compute/outputs.tf << 'EOF'
output "instance_ids" {
  value = aws_instance.web[*].id
}

output "instance_public_ips" {
  value = aws_instance.web[*].public_ip
}
EOF

# modules/storage/main.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/storage/main.tf << 'EOF'
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "app" {
  bucket = "${var.bucket_prefix}-${var.environment}-${random_id.bucket_suffix.hex}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "${var.bucket_prefix}-${var.environment}"
    Environment = var.environment
  }
}
EOF

# modules/storage/variables.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/storage/variables.tf << 'EOF'
variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "bucket_prefix" {
  type    = string
  default = "app-bucket"
}
EOF

# modules/storage/outputs.tf
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/modules/storage/outputs.tf << 'EOF'
output "bucket_name" {
  value = aws_s3_bucket.app.id
}

output "bucket_arn" {
  value = aws_s3_bucket.app.arn
}
EOF

# terraform.tfvars.example
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/terraform.tfvars.example << 'EOF'
ami_id          = "ami-0abcdef1234567890"
region          = "us-east-1"
environment     = "dev"
instance_count  = 1
instance_type   = "t3.micro"
app_bucket_prefix = "tf-aws-webserver-app"
EOF

# README.md
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/README.md << 'EOF'
# Terraform AWS Webserver - Modular

This repository refactors a simple webserver Terraform configuration into modules and adds a bootstrap for remote state.

Structure:
- backend-bootstrap: deploys S3 bucket + DynamoDB table for remote state
- modules: network, security, compute, storage
- root: wires modules together and configures backend (backend.tf is a placeholder; use terraform init -backend-config)

Quick start:
1. Create backend resources:
   cd backend-bootstrap
   terraform init
   terraform apply -auto-approve -var="bucket_name=your-unique-tfstate-bucket-12345" -var="region=us-east-1" -var="environment=dev"

2. Configure root backend:
   cd ..
   terraform init \
     -backend-config="bucket=your-unique-tfstate-bucket-12345" \
     -backend-config="key=terraform-aws-webserver/terraform.tfstate" \
     -backend-config="region=us-east-1" \
     -backend-config="dynamodb_table=tf-state-lock"

3. Plan & apply:
   terraform fmt -recursive
   terraform validate
   terraform plan -var="ami_id=ami-0abcdef1234567890"
   terraform apply -var="ami_id=ami-0abcdef1234567890" -auto-approve

Important:
- Do not check real state files into VCS.
- The bootstrap bucket must be globally unique.
EOF

# .gitignore
cat > /Users/saimausman/Documents/Learn-Terraform/Terraform-modules/.gitignore << 'EOF'
# Local Terraform files
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl
terraform.tfvars
EOF

echo "✅ Terraform-modules project structure created successfully!"
echo "📁 Location: /Users/saimausman/Documents/Learn-Terraform/Terraform-modules"
echo ""
echo "📋 Project structure:"
tree /Users/saimausman/Documents/Learn-Terraform/Terraform-modules
