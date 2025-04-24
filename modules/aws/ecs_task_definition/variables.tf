variable "name" {
  description = "The name of the ECS service."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}

# ECS Task Definition
# ===================================
variable "launch_type" {
  description = "The launch type to use for the ECS task."
  type        = set(string)
  default     = ["FARGATE"]
}

variable "cpu_architecture" {
  description = "The CPU architecture to use for the ECS task."
  type        = string
  default     = "X86_64"
  validation {
    condition     = contains(["X86_64", "ARM64"], var.cpu_architecture)
    error_message = "CPU architecture must be one of 'X86_64' or 'ARM64'."
  }
}

variable "operating_system_family" {
  description = "The operating system family to use for the ECS task."
  type        = string
  default     = "LINUX"
}

variable "cpu" {
  description = "The number of CPU units to use for the ECS task."
  type        = string
}

variable "memory" {
  description = "The amount of memory (in MiB) to use for the ECS task."
  type        = string
}

variable "network_mode" {
  description = "The network mode to use for the ECS task."
  type        = string
  default     = "awsvpc"
  validation {
    condition     = contains(["none", "bridge", "host", "awsvpc"], var.network_mode)
    error_message = "Network mode must be one of 'bridge', 'host', or 'awsvpc'."
  }
}

variable "container_definitions" {
  description = "A list of container definitions for the ECS task."
  type = list(object({
    name      = string
    image     = string
    cpu       = number
    memory    = number
    essential = bool
    environment = list(object({
      name  = string
      value = string
    }))
    port_mappings = list(object({
      container_port = number
      host_port      = number
      protocol       = string
    }))
  }))

}

variable "region" {
  description = "The AWS region to deploy the ECS service."
  type        = string
}

variable "ephemeral_storage_size" {
  description = "The size of the ephemeral storage in GB."
  type        = number
  default     = 21
  validation {
    condition     = var.ephemeral_storage_size >= 21 && var.ephemeral_storage_size <= 200
    error_message = "Ephemeral storage size must be between 21 GB and 200 GB."
  }

}

# CloudWatch Log Group
# ===================================
variable "log_retention_in_days" {
  description = "The number of days to retain log events in the specified log group."
  type        = number
  default     = 30
}
