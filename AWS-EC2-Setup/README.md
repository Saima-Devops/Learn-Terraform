# Terraform AWS EC2 Setup

This project demonstrates how to provision an **EC2 instance on AWS using Terraform** in a clean and modular way.

---

## Project Structure

```
.
├── terraform.tf      # Backend / Terraform settings
├── providers.tf      # AWS provider configuration
├── ec2.tf            # EC2 instance + networking resources
├── terra-key-ec2     # Private key (SSH)
├── terra-key-ec2.pub # Public key
```

---

## Prerequisites

Make sure you have:

- Terraform installed
- AWS account
- AWS CLI configured

---

## Configure AWS Credentials

Run:

```bash
aws configure
```

Enter:

```
AWS Access Key ID
AWS Secret Access Key
Region (e.g., us-east-1)
```

---

## SSH Key Pair

Generate SSH keys using:

```bash
ssh-keygen
```
OR
```bash
ssh-keygen -t rsa -b 2048 -f terra-key-ec2
```

This creates:

* `terra-key-ec2` → private key (keep safe)
* `terra-key-ec2.pub` → public key (used by Terraform)

---

## How to Create EC2 Instance?

### Step 1: Write a `.tf` file with complete configuration details

`nano ec2.tf` or any name of your choice or `main.tf` (best practices)

```hcl
# This script will create an EC2 instance on AWS using Terraform.

# Generate Key Pair (login)
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# Default VPC
resource "aws_default_vpc" "default" {}

# Security Group
resource "aws_security_group" "aws_security_groupTG" {
  name        = "TF-Saim-SG"
  description = "This is TF generated SG by Saima"
  vpc_id      = aws_default_vpc.default.id

  # Inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ restrict in production, change accordingly
    description = "SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  #semantically equivalent to all ports
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "allow-all-traffic"
  }
}

# EC2 Instance
resource "aws_instance" "Saim_TF_instance" {
  ami           = "ami-07216ac99dc46a187" # ⚠️ region-specific ubuntu OS
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key.key_name

  # ✅ Correct way for VPC
  vpc_security_group_ids = [aws_security_group.aws_security_groupTG.id]

  root_block_device {  #root volume of ec2
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name = "Saim_TF_instance"
  }
}
```
------

### Step 2: Write providers.tf file for AWS

```bash
provider "aws" {
    region = "ap-south-1"
}
```


### Step 3: Initialize Terraform

```bash
terraform init
```

---

### Step 4: Validate configuration

```bash
terraform validate
```

---

### Step 5: Preview resources

```bash
terraform plan
```

---

### Step 6: Create EC2 instance

```bash
terraform apply
OR
terraform apply -auto-approve
```

⏱️ Within ~1 minute, your EC2 instance will be created.

---

## Get Public IP

After apply completes, Terraform will output:

```
public_ip = x.x.x.x
```

---

## Connect to EC2 via SSH

```bash
ssh -i terra-key-ec2 ubuntu@<PUBLIC_IP>
```

---

## Destroy Resources

To delete everything after practice:

```bash
terraform destroy
OR
terraform destroy -auto-approve
```

---

## Notes

* Make sure port **22 (SSH)** is open in your security group
* Restrict SSH access to your IP for better security
* AMI IDs are region-specific

---

## Summary

With just a few commands:

```bash
terraform init
terraform apply
```

You can provision a fully working EC2 instance in under a minute 🚀

---

## Author

Saima - Terraform AWS Practice
