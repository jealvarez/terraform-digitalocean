terraform {
  required_version = ">= 0.11.7"
}

variable "name" {
  type        = "string"
  description = "SSH-Key name that will be created on DigitalOcean"
}

variable "public_key" {
  type        = "string"
  description = "Path of the ssh public key"
}
