variable "name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the ECS cluster"
  type        = map(string)
}

# ECS Cluster
# ===================================
variable "container_insights" {
  description = "Enable or disable container insights for the ECS cluster. Options are 'enabled', 'disabled', or 'enhanced'."
  type        = string
  default     = "enhanced"
  validation {
    condition     = contains(["enabled", "disabled", "enhanced"], var.container_insights)
    error_message = "container_insights must be one of 'enabled', 'disabled', or 'enhanced'."
  }
}

# CloudWatch Log Group
# ===================================
variable "log_retention_in_days" {
  description = "The number of days to retain log events in the specified log group."
  type        = number
  default     = 30
}