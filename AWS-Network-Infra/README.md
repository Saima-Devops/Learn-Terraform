# AWS Network Infrastructure using Terraform

## Project Overview

This project demonstrates how to provision a basic AWS network infrastructure using Terraform.

The infrastructure includes:

* A Virtual Private Cloud (VPC)
* One Public Subnet
* One Private Subnet
* An Internet Gateway (IGW)
* A Public Route Table
* Route Table Association for the Public Subnet

The goal is to create a simple and reusable Infrastructure as Code (IaC) solution that follows AWS networking best practices.

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
                ┌─────────────┐
                │             │
                │             │
      Public Subnet      Private Subnet
      10.0.1.0/24        10.0.2.0/24
      us-east-1a         us-east-1b
                │
                │
         Route Table
      0.0.0.0/0 → IGW
```

---

## Infrastructure Components

### VPC

| Property   | Value       |
| ---------- | ----------- |
| Name       | main-vpc    |
| CIDR Block | 10.0.0.0/16 |

### Public Subnet

| Property             | Value         |
| -------------------- | ------------- |
| Name                 | public-subnet |
| CIDR Block           | 10.0.1.0/24   |
| Availability Zone    | us-east-1a    |
| Public IP Assignment | Enabled       |

### Private Subnet

| Property             | Value          |
| -------------------- | -------------- |
| Name                 | private-subnet |
| CIDR Block           | 10.0.2.0/24    |
| Availability Zone    | us-east-1b     |
| Public IP Assignment | Disabled       |

### Internet Gateway

| Property | Value    |
| -------- | -------- |
| Name     | main-igw |

### Route Table

| Route Destination | Target           |
| ----------------- | ---------------- |
| 0.0.0.0/0         | Internet Gateway |

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

## Project Structure

```text
terraform-network/
│
├── provider.tf
├── vpc.tf
├── outputs.tf
└── README.md
```

---

## Terraform Files

### provider.tf

Contains:

* Terraform version constraints
* AWS provider configuration
* AWS region settings

### vpc.tf

Contains:

* VPC
* Public Subnet
* Private Subnet
* Internet Gateway
* Route Table
* Route Table Association

### outputs.tf

Contains:

* VPC ID
* Public Subnet ID
* Private Subnet ID
* Internet Gateway ID

---

## Deployment Steps

### Step 1: Clone the Repository

```bash
git clone https://github.com/Saima-Devops/Learn-Terraform.git
cd AWS-Network-Infra
```

---

### Step 2: Initialize Terraform

```bash
terraform init
```

Expected output:

```text
Terraform has been successfully initialized!
```

---

### Step 3: Validate Configuration

```bash
terraform validate
```

Expected output:

```text
Success! The configuration is valid.
```

---

### Step 4: Review Execution Plan

```bash
terraform plan
```

This command displays the resources Terraform will create.

---

### Step 5: Deploy Infrastructure

```bash
terraform apply
```

When prompted:

```text
Enter a value: yes
```

Terraform will provision the infrastructure in AWS.

---

## Verification

After deployment, verify resources in the AWS Console:

### VPC Dashboard

Verify:

* VPC created
* CIDR block is 10.0.0.0/16

### Subnets

Verify:

* Public Subnet (10.0.1.0/24)
* Private Subnet (10.0.2.0/24)

### Internet Gateway

Verify:

* Internet Gateway exists
* Attached to the VPC

### Route Tables

Verify:

* Route 0.0.0.0/0 points to Internet Gateway
* Route Table associated with Public Subnet

---

## Terraform Outputs

Display outputs:

```bash
terraform output
```

Example:

```text
vpc_id = "vpc-xxxxxxxx"
public_subnet_id = "subnet-xxxxxxxx"
private_subnet_id = "subnet-xxxxxxxx"
internet_gateway_id = "igw-xxxxxxxx"
```

---

## Cleanup

To remove all resources and avoid AWS charges:

```bash
terraform destroy
```

Confirm:

```text
Enter a value: yes
```

Terraform will delete all created resources.

---

## Learning Outcomes

By completing this project, you will gain hands-on experience with:

* Terraform fundamentals
* Infrastructure as Code (IaC)
* AWS VPC networking
* Public and private subnet design
* Internet Gateway configuration
* Route Tables and routing
* Terraform deployment lifecycle

---

## Author
Saima Usman
Jr. DevOps & Cloud Engineer

Created as a foundational Infrastructure as Code project for AWS cloud networking and Terraform automation.
