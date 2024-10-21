terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.1"
    }
  }

  required_version = ">= 1.0"  # Specify the required Terraform version
}

provider "aws" {
  region = "us-west-2" 
}

resource "aws_instance" "github_runner" {
  ami           = "ami-0866a3c8686eaeeba"  # Ensure this AMI ID is valid in your region
  instance_type = "t2.micro"

  # Optional: Add a name tag for easier identification
  tags = {
    Name = "github-runner"
  }

  # Optional: If you want to allow SSH access, you might want to add a security group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (not recommended for production)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}
