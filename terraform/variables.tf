variable "ssh_cidr" {
  description = "CIDR allowed to SSH to the instance, e.g. your public IP with /32"
  type        = string

  validation {
    condition     = var.ssh_cidr != "0.0.0.0/0"
    error_message = "ssh_cidr must not be 0.0.0.0/0 (SSH open to the whole internet)."
  }
}
