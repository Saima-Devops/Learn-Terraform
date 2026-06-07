# What is Terraform?

**Terraform** is an open-source IaC tool developed by **HashiCorp** that allows you to define, provision, and manage infrastructure using simple, declarative configuration files.

Instead of manually creating cloud resources, Terraform lets you describe your infrastructure in code using HCL. These configurations can then be version-controlled, reused, and shared—bringing the same discipline of software development to infrastructure management.

----

## Why use Terraform?

- **Cloud-agnostic**: Works with multiple providers like Amazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform

- **Declarative syntax**: Define what you want, Terraform figures out how to create it

- **State management**: Keeps track of infrastructure changes and dependencies

- **Automation-friendly**: Easily integrates into CI/CD pipelines

- **Scalable & reusable**: Use modules to organize and reuse code

-----

## How it works

Terraform follows a simple workflow:

- **Write** – Define infrastructure in .tf files
  
- **Plan** – Preview changes before applying

- **Apply** – Provision infrastructure safely

- **Manage** – Update or destroy resources when needed

---------

## Example

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```

> This configuration launches a virtual machine instance on AWS with minimal effort.

----

## Summary

**Terraform** helps teams automate infrastructure, reduce human error, and maintain consistent environments across development, testing, and production. It’s a powerful tool for modern DevOps workflows and cloud-native applications.


----
