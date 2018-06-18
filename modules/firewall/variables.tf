terraform {
  required_version = ">= 0.11.7"
}

variable "name" {
  type        = "string"
  description = "Firewall name"
}

variable "droplet_tags" {
  type        = "list"
  description = "Specify the droplet tags that will be assigned to the firewall"
}

variable "inbound_rules" {
  type        = "list"
  description = "Firewall inbound rules"

  default = [
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
}

variable "outbound_rules" {
  type        = "list"
  description = "Firewall outbound rules"

  default = [
    {
      protocol              = "tcp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "udp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]
}
