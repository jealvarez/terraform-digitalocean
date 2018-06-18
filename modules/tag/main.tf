terraform {
  required_version = ">= 0.11.7"
}

resource "digitalocean_tag" "tag" {
  name = "${var.name}"
}
