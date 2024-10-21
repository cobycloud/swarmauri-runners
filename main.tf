terraform {
  required_providers {
    linux = {
      source  = "example/linux"  # Replace with the correct source for the linux provider
      version = "1.0.0"  # Adjust the version as needed
    }
  }
}

provider "linux" {
  host     = var.linux_host
  port     = var.linux_port
  user     = var.linux_user
  password = var.linux_password
}

resource "linux_directory" "directory" {
  path         = "/tmp/linux/dir"
  owner        = 1000
  group        = 1000
  mode         = "755"
  overwrite    = true
  recycle_path = "/tmp/recycle"
}

resource "linux_file" "file" {
  path    = "/tmp/linux/file"
  content = <<-EOF
    hello world
  EOF
  owner         = 1000
  group         = 1000
  mode          = "644"
  overwrite     = true
  recycle_path  = "/tmp/recycle"
}

locals {
  package_name = "apache2"
}

resource "linux_script" "install_package" {
  lifecycle_commands {
    create = "apt update && apt install -y ${PACKAGE_NAME}=${PACKAGE_VERSION}"
    read   = "apt-cache policy ${PACKAGE_NAME} | grep 'Installed:' | grep -v '(none)' | awk '{ print $2 }' | xargs | tr -d '\n'"
    update = "apt update && apt install -y ${PACKAGE_NAME}=${PACKAGE_VERSION}"
    delete = "apt remove -y ${PACKAGE_NAME}"
  }

  environment = {
    PACKAGE_NAME    = local.package_name
    PACKAGE_VERSION = "2.4.18-2ubuntu3.4"  # Adjust the version as necessary
  }

  triggers = {
    PACKAGE_NAME = local.package_name
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
