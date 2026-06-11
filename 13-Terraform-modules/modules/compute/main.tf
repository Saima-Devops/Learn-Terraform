resource "aws_instance" "web" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name        = "${var.environment}-web-${count.index}"
    Environment = var.environment
  }

  root_block_device {
    volume_size           = 8
    delete_on_termination = true
  }
}
