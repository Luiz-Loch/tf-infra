# General Configuration
# ===================================
variable "vpc_id" {
  description = "VPC ID where the Load Balancer will be created"
  type        = string
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
}

# ALB Security Group
# ===================================
variable "ingress_ports" {
  description = "A set of ingress port configurations for the security group."
  type = set(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "egress_ports" {
  description = "A set of egress port configurations for the security group."
  type = set(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

# Application Load Balancer
# ===================================
variable "name" {
  description = "Name of the Load Balancer"
  type        = string
}

variable "internal" {
  description = "Whether the Load Balancer is internal (true) or public (false)"
  type        = bool
  default     = false
}

variable "subnets" {
  description = "List of subnets for the Load Balancer"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enables or disables deletion protection for the Load Balancer"
  type        = bool
  default     = false
}

# Load Balancer listener
# ===================================
variable "ssl_policy" {
  description = "SSL policy to use for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "enable_https_listener" {
  description = "Whether to enable HTTPS listener"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
  default     = null
}


# Load Balancer Target Group
# ===================================
variable "target_groups" {
  description = "Map of target groups to create"
  type = map(object({
    load_balancing_algorithm_type = string # RoundRobin or LeastOutstandingRequests
    port                          = number
    path                          = string
    protocol                      = string
    target_type                   = string
    health_check = object({
      enabled             = bool
      healthy_threshold   = number
      interval            = number
      path                = string
      port                = string
      timeout             = number
      unhealthy_threshold = number
    })
  }))
  default = {}
}
