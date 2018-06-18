terraform {
  required_version = ">= 0.11.7"
}

output "fingerprint" {
  value       = ["${digitalocean_ssh_key.ssh_key.fingerprint}"]
  description = "Fingerprint of the ssh key specified in the input"
}
