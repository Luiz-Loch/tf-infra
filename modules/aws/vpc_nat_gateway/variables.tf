# Elastic IP
# ===================================
variable "elastic_ip_domain" {
  type        = string
  default     = "vpc"
  description = "Restrict the elastic ip to a specific vpc"
}

# NAT Gateway
# ===================================
variable "public_subnet_id" {
  description = "The ID of the public subnet where the NAT Gateway will be created"
  type        = string
  validation {
    condition     = length(var.public_subnet_id) > 0
    error_message = "The public_subnet_id must not be empty."
  }
}

variable "tags" {
  description = "Additional tags for the NAT Gateway"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "The name of the NAT Gateway"
  type        = string
}

