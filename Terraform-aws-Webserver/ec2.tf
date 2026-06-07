resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (free tier friendly)
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  key_name = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>WELCOME TO MY WEB SERVER - TERRAFORM </h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "web-server"
  }
}