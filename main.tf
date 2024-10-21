terraform {
  required_providers {
    linux = {
      source = "example/linux"
      version = "1.0.0"
    }
  }
}

provider "linux" {
  # Replace with your actual configuration to connect to the Ubuntu machine
  host     = "<IP_ADDRESS>"
  user     = "<USERNAME>"
  password = "<PASSWORD>"
}

resource "linux_instance" "runner" {
  name      = "ubuntu-github-runner"
  os        = "ubuntu"
}
