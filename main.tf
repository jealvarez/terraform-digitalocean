terraform {
  required_version = ">= 0.11.7"
}

provider "digitalocean" {
  token   = "${local.digitalocean_token}"
  version = "~> 0.1"
}

# docker tag
module "docker_tag" {
  source = "./modules/tag"
  name   = "docker"
}

# docker ssh-key
module "docker_ssh_key" {
  source     = "./modules/ssh-key"
  name       = "Docker"
  public_key = "${local.public_key}"
}

# docker droplet
module "docker_vm" {
  source              = "./modules/droplets/docker"
  image               = "ubuntu-17-10-x64"
  name                = "containerized-apps"
  region              = "nyc1"
  size                = "1gb"
  tags                = ["${module.docker_tag.tag_id}"]
  private_key         = "${local.private_key}"
  ssh_key_fingerprint = ["${module.docker_ssh_key.fingerprint}"]
}

# docker firewall
module "docker_vm_firewall" {
  source       = "./modules/firewall"
  name         = "docker-firewall"
  droplet_tags = ["${module.docker_tag.tag_id}"]
}
