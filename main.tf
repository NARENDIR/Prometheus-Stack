# Configure the AWS provider
provider "aws" {
  region = "us-east-1"  # Update with your desired region
}

# Create a security group to allow SSH access
resource "aws_security_group" "allow_ssh" {
  name = "prometheus-sg"
  description = "Security group for Prometheus Stack"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (update for production)
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}

# Create an EC2 instance with user data script
resource "aws_instance" "prometheus_server" {
  ami           = "ami-0123456789abcdef0"  # Replace with desired AMI ID
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # User data script to install Docker and Docker Compose
  user_data = <<EOF
  #!/bin/bash
  yum update -y
  yum install -y docker docker-compose
  systemctl start docker
  systemctl enable docker
  EOF
}
