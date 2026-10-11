variable "ssh_cidr" {
  description = "CIDR allowed to SSH to the instance, e.g. your public IP with /32"
  type        = string

  validation {
    condition     = var.ssh_cidr != "0.0.0.0/0"
    error_message = "ssh_cidr must not be 0.0.0.0/0 (SSH open to the whole internet)."
  }
}

variable "app_cidr" {
  description = "CIDR allowed to reach the app on port 500 (your public IP with /32)"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the public key to install on the instance"
  type        = string
  default     = "~/.ssh/tracker-key.pub"
}
