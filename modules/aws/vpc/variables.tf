variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "The CIDR block must be a valid value."
  }
}

variable "instance_tenancy" {
  description = "The tenancy option for instances in the VPC (default or dedicated)"
  type        = string
  default     = "default"
  validation {
    condition     = contains(["default", "dedicated"], var.instance_tenancy)
    error_message = "The instance_tenancy value must be either 'default' or 'dedicated'."
  }
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
}

variable "name" {
  description = "The name of the VPC"
  type        = string
}
