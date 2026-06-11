# Terraform AWS Webserver - Modular Approach

This repository refactors a simple webserver Terraform configuration into modules and adds a bootstrap for remote state.

## Objective: 

Refactor your infrastructure using modules and remote state.
Requirements:
● Create an S3 bucket for Terraform state storage
● Configure Terraform to use the S3 bucket as a backend
● Refactor your previous code into the following modules:
   ○ Network module (VPC, subnets, etc.)
   ○ Security module (security groups)
   ○ Compute module (EC2 instances)
   ○ Storage module (S3 buckets)

● Use variables and outputs to connect the modules
● Apply the refactored configuration
 

** Expected Outcome:** A modular Terraform configuration with remote state management.


----

## Structure:
- backend-bootstrap: deploys S3 bucket + DynamoDB table for remote state
- modules: network, security, compute, storage
- root: wires modules together and configures backend (backend.tf is a placeholder; use terraform init -backend-config)

## Quick start:
1. **Create backend resources:**
   cd backend-bootstrap
   terraform init
   terraform apply -auto-approve -var="bucket_name=your-unique-tfstate-bucket-12345" -var="region=us-east-1" -var="environment=dev"

2. **CConfigure root backend:**
   cd ..
   terraform init \
     -backend-config="bucket=your-unique-tfstate-bucket-12345" \
     -backend-config="key=terraform-aws-webserver/terraform.tfstate" \
     -backend-config="region=us-east-1" \
     -backend-config="dynamodb_table=tf-state-lock"

3. **Plan & apply:**
   terraform fmt -recursive
   terraform validate
   terraform plan -var="ami_id=ami-0abcdef1234567890"
   terraform apply -var="ami_id=ami-0abcdef1234567890" -auto-approve

**Important:**
- Do not check real state files into VCS.
- The bootstrap bucket must be globally unique.

----

## Author
**Saima Usman** \
Jr. DevOps & Cloud Engineer 
