variable "vpc_id" {
  description = "The ID of the VPC where the subnet will be created"
  type        = string
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "The vpc_id must not be empty."
  }
}

variable "cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "The CIDR block must be a valid value."
  }
}

variable "availability_zone" {
  description = "The availability zone for the subnet (optional)"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Enable public IP assignment on launch"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for the subnet"
  type        = map(string)
}

variable "name" {
  description = "The name of the subnet"
  type        = string
}
