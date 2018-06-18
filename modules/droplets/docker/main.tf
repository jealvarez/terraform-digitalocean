terraform {
  required_version = ">= 0.11.7"
}

resource "digitalocean_droplet" "docker_droplet" {
  image              = "${var.image}"
  name               = "${var.name}"
  region             = "${var.region}"
  size               = "${var.size}"
  private_networking = "${var.private_networking}"
  tags               = ["${var.tags}"]

  ssh_keys = ["${var.ssh_key_fingerprint}"]

  connection {
    user        = "${var.connection_user}"
    type        = "${var.connection_type}"
    private_key = "${var.private_key}"
    timeout     = "1m"
  }

  provisioner "file" {
    source      = "./modules/droplets/docker/scripts/install-apache2.sh"
    destination = "/tmp/install-apache2.sh"
  }

  provisioner "file" {
    source      = "./modules/droplets/docker/scripts/install-docker.sh"
    destination = "/tmp/install-docker.sh"
  }

  provisioner "file" {
    source      = "./modules/droplets/docker/scripts/install-letsencrypt.sh"
    destination = "/tmp/install-letsencrypt.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-apache2.sh",
      "chmod +x /tmp/install-docker.sh",
      "chmod +x /tmp/install-letsencrypt.sh",
      "/tmp/install-apache2.sh",
      "/tmp/install-letsencrypt.sh",
      "/tmp/install-docker.sh",
    ]
  }
}
