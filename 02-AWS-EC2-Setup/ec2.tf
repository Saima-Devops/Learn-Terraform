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
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ restrict in production
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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "allow-all-traffic"
  }
}

# EC2 Instance
resource "aws_instance" "Saim_TF_instance" {
  ami           = "ami-07216ac99dc46a187" # ⚠️ region-specific
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key.key_name

  # ✅ Correct way for VPC
  vpc_security_group_ids = [aws_security_group.aws_security_groupTG.id]

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name = "Saim_TF_instance"
  }
}
