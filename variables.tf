terraform {
  required_version = ">= 0.11.7"
}

locals {
  digitalocean_token = ""
  private_key        = "${file("./ssh-keys/id_rsa")}"
  public_key         = "${file("./ssh-keys/id_rsa.pub")}"
}
