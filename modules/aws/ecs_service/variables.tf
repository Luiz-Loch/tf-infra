# ECS Service
# ===================================
variable "name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the ECS Service"
  type        = map(string)
}

variable "cluster_arn" {
  description = "The ARN of the ECS cluster"
  type        = string
}

variable "task_definition_arn" {
  description = "The ARN of the ECS task definition"
  type        = string
}

variable "desired_count" {
  description = "The desired number of tasks to run"
  type        = number
  default     = 2
}

variable "launch_type" {
  description = "The launch type to use for the ECS service"
  type        = string
  default     = "FARGATE"
  validation {
    condition     = contains(["EC2", "FARGATE", "EXTERNAL"], var.launch_type)
    error_message = "Launch type must be either 'EC2', 'FARGATE' or 'EXTERNAL'."
  }
}

variable "platform_version" {
  description = "The platform version to use for the ECS service"
  type        = string
  default     = "LATEST"
}

variable "availability_zone_rebalancing" {
  description = "Whether to enable availability zone rebalancing"
  type        = string
  default     = "ENABLED"
  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.availability_zone_rebalancing)
    error_message = "Availability zone rebalancing must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "deployment_minimum_healthy_percent" {
  description = "The minimum percentage of tasks that must remain healthy during a deployment"
  type        = number
  default     = 100
}

variable "deployment_maximum_percent" {
  description = "The maximum percentage of tasks that can be running during a deployment"
  type        = number
  default     = 200

}

variable "network_configuration" {
  description = "The network configuration for the ECS service"
  type = object({
    subnets          = set(string)
    security_groups  = set(string)
    assign_public_ip = bool
  })
}

variable "load_balancer" {
  description = "The load balancer configuration for the ECS service"
  type = object({
    container_name   = string
    container_port   = number
    target_group_arn = string
  })
}

variable "enable_execute_command" {
  description = "Whether to enable the execute command feature for the ECS service"
  type        = bool
  default     = false
}