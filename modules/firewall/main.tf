terraform {
  required_version = ">= 0.11.7"
}

resource "digitalocean_firewall" "firewall" {
  name = "${var.name}"

  tags = ["${var.droplet_tags}"]

  inbound_rule = "${var.inbound_rules}"

  outbound_rule = "${var.outbound_rules}"
}
