resource "aws_security_group" "web_sg" {
  name        = "type-constraints-web-sg-${var.environment}"
  description = "Allow HTTP and SSH"
  vpc_id      = null

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_instance" "web_server" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.server_config.instance_type
  monitoring    = var.server_config.monitoring

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  root_block_device {
    volume_size           = var.server_config.storage_gb
    delete_on_termination = true
  }

  tags = merge(local.common_tags, { InstanceIndex = tostring(count.index) })
}