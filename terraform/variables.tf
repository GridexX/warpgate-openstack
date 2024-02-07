variable "image_name" {
  default = "debian-12.0.0"
}

variable "flavor_name" {
  default = "m1.small"
}

variable instance_name {
  default = "warpgate"
}

variable "public_network_name" {
  default = "public2"
}

variable "create_random_suffix" {
  default = true
}

variable "public_key_pair_path" {
  default = "~/.ssh/id_k0s.pub"
}

variable "ssh_user" {
  default = "debian"
}