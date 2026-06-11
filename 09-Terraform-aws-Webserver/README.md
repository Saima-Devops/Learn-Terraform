# AWS Web Server Infrastructure using Terraform

## Project Overview

This project demonstrates how to provision a complete web server infrastructure on AWS using Terraform.

The infrastructure reuses an existing VPC and deploys an Apache web server on an EC2 instance within a public subnet. The project also provisions an Amazon S3 bucket with versioning enabled for storing static content.

The solution follows Infrastructure as Code (IaC) principles, making the deployment repeatable, scalable, and easy to manage.

---

## Objectives

* Reuse an existing AWS VPC infrastructure
* Create a Security Group allowing HTTP and SSH access
* Launch an EC2 instance in a public subnet
* Automatically install and configure Apache Web Server using Terraform `user_data`
* Create an S3 bucket with versioning enabled
* Implement reusable Terraform variables
* Output the public IP address and website URL

---

## Architecture

```text
                          Internet
                              │
                              │
                    Internet Gateway
                              │
                              │
                     VPC (10.0.0.0/16)
                              │
        ┌─────────────────────┴─────────────────────┐
        │                                           │
        │                                           │
 Public Subnet                               Private Subnet
 (10.0.1.0/24)                             (10.0.2.0/24)
        │
        │
        ▼
  EC2 Instance
 (Apache Web Server)
        │
        │
 Security Group
  - SSH (22)
  - HTTP (80)

        ▼

   S3 Bucket
 (Versioning Enabled)
```

---

## Infrastructure Components

### Networking

| Resource         | Configuration                    |
| ---------------- | -------------------------------- |
| VPC              | 10.0.0.0/16                      |
| Public Subnet    | 10.0.1.0/24                      |
| Private Subnet   | 10.0.2.0/24                      |
| Internet Gateway | Attached to VPC                  |
| Route Table      | Public route to Internet Gateway |

### Compute

| Resource      | Configuration                 |
| ------------- | ----------------------------- |
| EC2 Instance  | Amazon Linux                  |
| Instance Type | t3.micro (Free Tier Eligible) |
| Web Server    | Apache HTTP Server            |

### Security

| Protocol | Port | Purpose     |
| -------- | ---- | ----------- |
| TCP      | 22   | SSH Access  |
| TCP      | 80   | HTTP Access |

### Storage

| Resource   | Configuration          |
| ---------- | ---------------------- |
| S3 Bucket  | Static Content Storage |
| Versioning | Enabled                |

---

## Project Structure

```text
Terraform-aws-Webserver/
│
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── data.tf
├── security-group.tf
├── ec2.tf
├── s3.tf
├── outputs.tf
├── README.md
└── .gitignore
```

---

## Prerequisites

Before deploying the infrastructure, ensure the following tools are installed:

### Terraform

Verify installation:

```bash
terraform version
```

### AWS CLI

Verify installation:

```bash
aws --version
```

Configure AWS credentials:

```bash
aws configure
```

Verify authentication:

```bash
aws sts get-caller-identity
```

---

## Terraform Variables

### variables.tf

```hcl
variable "region" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}
```

### terraform.tfvars

```hcl
region        = "us-east-1"
instance_type = "t3.micro"
key_name      = "my-keypair"
```

---

## Deployment Steps

### 1. Clone the Repository

```bash
git clone https://github.com/Saima-Devops/Learn-Terraform.git
cd Terraform-aws-Webserver
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Validate Configuration

```bash
terraform validate
```

### 4. Review Execution Plan

```bash
terraform plan
```

### 5. Deploy Infrastructure

```bash
terraform apply
```

When prompted:

```text
yes
```

Terraform will provision all AWS resources.

---

## Apache Installation using User Data

The EC2 instance uses a bootstrap script to automatically install and start Apache.

```bash
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

echo "<h1>WELCOME TO MY WEB SERVER - TERRAFORM</h1>" > /var/www/html/index.html
```

---

## Accessing the Website

After deployment, Terraform outputs the public IP address of the EC2 instance.


**Open the URL in a browser:**

```text
http://<EC2_PUBLIC_IP>
```

**Expected Output:**

```html
WELCOME TO MY WEB SERVER - TERRAFORM
```

---

## Outputs

Display outputs using:

```bash
terraform output
```

Example:

```text
ec2_public_ip = "54.xx.xx.xx"
website_url = "http://54.xx.xx.xx"
s3_bucket_name = "terraform-static-content-bucket"
```

---

## Verify S3 Bucket Versioning

```bash
aws s3api get-bucket-versioning --bucket <bucket-name>
```

Expected Output:

```json
{
  "Status": "Enabled"
}
```

---

## Cleanup

To avoid AWS charges, destroy all resources when finished:

```bash
terraform destroy
```

Confirm:

```text
yes
```

Terraform will remove all deployed infrastructure.

---

## Learning Outcomes

This project provides hands-on experience with:

* Terraform fundamentals
* Infrastructure as Code (IaC)
* AWS VPC networking
* Public and private subnets
* Security Groups
* EC2 provisioning
* User Data automation
* Apache Web Server deployment
* Amazon S3 bucket management
* S3 versioning
* Terraform variables and outputs

---

## Best Practices Implemented

* Reusable Terraform variables
* Infrastructure as Code approach
* Automated server configuration using user data
* Principle of least privilege security configuration
* Version-controlled static content storage
* Free Tier eligible resources

---

## Author

**Saima Usman**

Terraform AWS Infrastructure Project
