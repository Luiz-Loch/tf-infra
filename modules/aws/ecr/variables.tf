variable "name" {
  type = string
}

variable "scan_on_push" {
  type    = bool
  default = false
}

variable "image_tag_mutability" {
  type    = string
  default = "MUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "The image_tag_mutability variable must be either MUTABLE or IMMUTABLE."
  }
}

variable "force_delete" {
  type    = bool
  default = true
}

variable "tags" {
  type = map(string)
}

variable "retention_tag_prefix" {
  description = "The tag prefix used to identify images that should be retained indefinitely. Images with tags starting with this prefix will not be subject to expiration."
  type        = string
  default     = ""
}

variable "retention_period_days" {
  description = "The number of days to retain images that do not match the specified tag prefix. Images older than this period will be expired."
  type        = number
  default     = 0
  validation {
    condition     = var.retention_period_days >= 0
    error_message = "The retention period in days must be a non-negative number."
  }
}
