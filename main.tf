terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"  # Adjust the version as needed
    }
  }
}

provider "null" {}

# Create directory and set ownership/permissions
resource "null_resource" "create_directory" {
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/linux/dir",
      "chown 1000:1000 /tmp/linux/dir",
      "chmod 755 /tmp/linux/dir"
    ]

    connection {
      type        = "ssh"
      host        = var.linux_host
      port        = var.linux_port
      user        = var.linux_user
      password    = var.linux_password
    }
  }

  triggers = {
    always_run = timestamp()
  }
}

# Create file with content and set ownership/permissions
resource "null_resource" "create_file" {
  provisioner "remote-exec" {
    inline = [
      "echo 'hello world' > /tmp/linux/file",
      "chown 1000:1000 /tmp/linux/file",
      "chmod 644 /tmp/linux/file"
    ]

    connection {
      type        = "ssh"
      host        = var.linux_host
      port        = var.linux_port
      user        = var.linux_user
      password    = var.linux_password
    }
  }

  triggers = {
    always_run = timestamp()
  }
}

locals {
  package_name = "apache2"
}

# Install Apache2 package
resource "null_resource" "install_package" {
  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt install -y ${local.package_name}=2.4.18-2ubuntu3.4"  # Adjust the version as necessary
    ]

    connection {
      type        = "ssh"
      host        = var.linux_host
      port        = var.linux_port
      user        = var.linux_user
      password    = var.linux_password
    }
  }

  triggers = {
    package_name = local.package_name
  }
}

variable "linux_host" {
  description = "The host for the Linux provider"
  type        = string
}

variable "linux_port" {
  description = "The port for the Linux provider"
  type        = number
  default     = 22
}

variable "linux_user" {
  description = "The user for the Linux provider"
  type        = string
}

variable "linux_password" {
  description = "The password for the Linux provider"
  type        = string
}
