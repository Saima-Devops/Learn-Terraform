# Terraform S3 Bucket Setup (Same Region as EC2)

This guide explains how to create an **Amazon S3 bucket using Terraform** and ensure it is deployed in the **same AWS region as your EC2 instance**.

---

## Overview

When working with AWS:

* **EC2 instances** are launched in a specific *Availability Zone* (AZ)
* **S3 buckets** are created at the *region level*

---

## Project Structure

```bash
.
├── terraform.tf
├── providers.tf
├── ec2.tf
├── s3.tf              # S3 bucket configuration
├── terra-key-ec2
├── terra-key-ec2.pub
```

---

## ⚙️ Prerequisites

* Terraform installed
* AWS account
* AWS CLI configured (`aws configure`)
* Existing EC2 Terraform setup

---

## Step 1: Confirm AWS Region

Make sure your provider is set to the same region as EC2:

```hcl
provider "aws" {
  region = "us-east-1" # give your region
}
```

---

## Step 2: Create S3 Bucket

Create a new file `s3.tf` and add:

```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = "saim-terraform-bucket-12345" # must be globally unique

  tags = {
    Name        = "My Terraform Bucket"
    Environment = "Dev"
  }
}
```

---

## Step 3: Enable Versioning (Recommended)

```hcl
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
```

---

## Step 4: Apply Terraform

```bash
terraform init
terraform plan
terraform apply
```

Type:

```bash
yes
```

---

## Step 5: Verify

* Go to AWS Console → S3
* Confirm your bucket exists
* Check region matches your EC2 instance

---

## Important Notes

* S3 bucket names must be **globally unique**
* S3 is **region-based**, not AZ-based
* Use consistent region across all Terraform files
* Avoid public access unless required

---

## Secure Your Bucket (Optional)

You can block public access:

```hcl
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}
```

---

## Summary

With just a few lines of Terraform:

* You can create an S3 bucket
* Keep it in the same region as EC2
* Enable versioning and security best practices

---

## Cleanup

To delete resources:

```bash
terraform destroy
```

---

## 📬 Author

Saima - Terraform AWS Practice
