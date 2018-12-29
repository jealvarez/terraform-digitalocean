terraform {
  required_version = ">= 0.11.7"
}

variable "digitalocean_token" {}

variable "tag_name" {}

variable "ssh_key" {
  default = {}
}

variable "droplet" {
  default = {
    image              = "ubuntu-18-04-x64"
    region             = "nyc1"
    size               = "s-1vcpu-1gb"
    private_networking = "true"
    connection_user    = "root"
    connection_type    = "ssh"
  }
}
