# Security group — controls what traffic can reach your EC2 instance
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Allow web and SSH traffic"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH from anywhere (we will restrict this later)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-web-sg"
    ManagedBy = "terraform"
  }
}

# EC2 instance — your web server
resource "aws_instance" "web" {
  ami                    = "ami-0d64bb532e0502c46"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "<h1>Hello from ${var.project_name} — built with Terraform</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name      = "${var.project_name}-web-server"
    ManagedBy = "terraform"
  }
}
