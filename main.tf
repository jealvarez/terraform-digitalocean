terraform {
  required_version = ">= 0.11.7"

  backend "s3" {
    skip_credentials_validation = true
  }
}

provider "digitalocean" {
  token   = "${var.digitalocean_token}"
  version = "~> 0.1.3"
}

# ------------------------------------------------------------------------
# SSH Key
# ------------------------------------------------------------------------
resource "digitalocean_ssh_key" "ssh_key" {
  name       = "${var.droplet["name"]}-${var.tag_name}"
  public_key = "${file(var.ssh_key["public_key"])}"
}

# ------------------------------------------------------------------------
# Tags
# ------------------------------------------------------------------------
resource "digitalocean_tag" "tag" {
  name = "${var.tag_name}"
}

# ------------------------------------------------------------------------
# Droplet
# ------------------------------------------------------------------------
resource "digitalocean_droplet" "droplet" {
  name               = "${var.droplet["name"]}"
  image              = "${var.droplet["image"]}"
  region             = "${var.droplet["region"]}"
  size               = "${var.droplet["size"]}"
  private_networking = "${var.droplet["private_networking"]}"

  tags = ["${digitalocean_tag.tag.id}"]

  ssh_keys = ["${digitalocean_ssh_key.ssh_key.fingerprint}"]

  connection {
    user        = "${var.droplet["connection_user"]}"
    type        = "${var.droplet["connection_type"]}"
    private_key = "${file(var.ssh_key["private_key"])}"
    timeout     = "1m"
  }

  provisioner "file" {
    source      = "./scripts/install-packages.sh"
    destination = "/tmp/install-packages.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-packages.sh",
      "/tmp/install-packages.sh",
    ]
  }
}

# ------------------------------------------------------------------------
# Firewalls
# ------------------------------------------------------------------------
resource "digitalocean_firewall" "firewall" {
  name        = "${var.droplet["name"]}"
  droplet_ids = ["${digitalocean_droplet.droplet.id}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]

  outbound_rule = [
    {
      protocol              = "tcp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0"]
    },
    {
      protocol              = "udp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0"]
    },
  ]
}
