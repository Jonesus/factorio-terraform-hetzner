terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}


# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {
  sensitive = true
}
variable "vm_size" {}
variable "vm_location" {}
variable "ssh_key" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

# Create a server
resource "hcloud_server" "factorio" {
  name        = "factorio"
  server_type = var.vm_size
  location    = var.vm_location
  image       = "docker-ce"
  keep_disk   = true
  user_data   = file("${path.module}/cloud-init.yaml")
  ssh_keys    = ["jones@desktop"]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
}

output "server_ip" {
  value = hcloud_server.factorio.ipv4_address
}
