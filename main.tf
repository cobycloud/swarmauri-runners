terraform {
  required_providers {
    linux = {
      source  = "example/linux"  # Replace with the correct source for the linux provider
      version = "1.0.0"  # Adjust the version as needed
    }
  }
}

provider "linux" {
  host     = "127.0.0.1"  # Change this to the appropriate host
  port     = 22
  user     = "root"
  password = "root"  # Use environment variables or secrets for sensitive data
}

resource "linux_directory" "directory" {
  path          = "/tmp/linux/dir"
  owner         = 1000
  group         = 1000
  mode          = "755"
  overwrite     = true
  recycle_path  = "/tmp/recycle"
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
