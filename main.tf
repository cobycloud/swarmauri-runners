terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Specify the version you want
    }
  }
}

provider "aws" {
  region = "us-west-2"  # Specify the region you want
}

resource "aws_instance" "github_runner" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with an Ubuntu AMI in your region
  instance_type = "t2.micro"  # Choose the instance type
}
