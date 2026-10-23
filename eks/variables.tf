variable "region" {
  description = "AWS region for the cluster"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "tracker-eks"
}

variable "kubernetes_version" {
  description = "Kubernetes version of the control plane"
  type        = string
  default     = "1.36"
}

variable "vpc_cidr" {
  description = "CIDR block of the cluster VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "admin_cidr" {
  description = "The only address allowed to reach the Kubernetes API, as a /32"
  type        = string

  validation {
    condition     = can(regex("/32$", var.admin_cidr))
    error_message = "admin_cidr must be a single address ending in /32."
  }
}

variable "node_instance_type" {
  description = "Instance type of the worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_count" {
  description = "Name of worker nodes"
  type        = number
  default     = 2
}