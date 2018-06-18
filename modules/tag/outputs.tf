terraform {
  required_version = ">= 0.11.7"
}

output "tag_id" {
  value       = ["${digitalocean_tag.tag.id}"]
  description = "DigitalOcean tag id of the tag created"
}
