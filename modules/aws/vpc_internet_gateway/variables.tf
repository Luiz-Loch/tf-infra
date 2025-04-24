variable "vpc_id" {
  description = "The ID of the VPC where the Internet Gateway will be attached"
  type        = string
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "The vpc_id must not be an empty string."
  }
}

variable "tags" {
  description = "Additional tags for the Internet Gateway"
  type        = map(string)
}

variable "name" {
  description = "The name of the Internet Gateway"
  type        = string
}
