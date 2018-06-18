terraform {
  required_version = ">= 0.11.7"
}

variable "image" {
  type        = "string"
  description = "DigitalOcean droplet image"
}

variable "name" {
  type        = "string"
  description = "Droplet name"
}

variable "region" {
  type        = "string"
  description = "DigitalOcean datacenter region"
}

variable "size" {
  type        = "string"
  description = "Droplet size"
}

variable "private_networking" {
  type        = "string"
  description = "Set `false` to disable private networking otherwise is `true` by default"
  default     = "true"
}

variable "tags" {
  type        = "list"
  description = "Droplet tags"
}

variable "connection_user" {
  type        = "string"
  description = "Username for connection type that is defined, by default is `root`"
  default     = "root"
}

variable "connection_type" {
  type        = "string"
  description = "Define the type of the connection to connect to droplet, by default is `ssh`"
  default     = "ssh"
}

variable "ssh_key_fingerprint" {
  type        = "list"
  description = "Define `ssh key fingerprint` to establish `ssh` connection"
}

variable "private_key" {
  type        = "string"
  description = "Path of the ssh private key that will be used to establish ssh connection though private/public key"
}
