terraform {
  required_version = ">= 0.11.7"
}

output "droplet_private_ipv4_address" {
  value = "${digitalocean_droplet.droplet.ipv4_address_private}"
}

output "droplet_public_ipv4_address" {
  value = "${digitalocean_droplet.droplet.ipv4_address}"
}
