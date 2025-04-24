variable "tags" {
  description = "A map of tags to be applied to the resources."
  type        = map(string)
}

# IAM Role
# ===================================

# IAM Policy
# ===================================

# IAM Role Policy Attachment
# ===================================

# Security Group
# ===================================
variable "vpc_id" {
  description = "The ID of the VPC where the resources will be deployed."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the ingress of EKS."
  type        = string
  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "The CIDR block must be a valid value."
  }
}

variable "ingress_ports" {
  description = "A set of ingress port configurations for the security group."
  type = set(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
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

# EKS
# ===================================
variable "name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "The desired Kubernetes version for your cluster, e.g., 1.32."
  type        = string
}

variable "enabled_cluster_log_types" {
  description = "A set of log types to enable for the cluster logging."
  type        = set(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  validation {
    condition     = alltrue([for log in var.enabled_cluster_log_types : contains(["api", "audit", "authenticator", "controllerManager", "scheduler"], log)])
    error_message = "Invalid log type. Allowed values: api, audit, authenticator, controllerManager, scheduler."
  }
}

# vpc_config
variable "subnet_ids" {
  description = "A list subnet IDs for the EKS cluster."
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Indicates whether the cluster API server endpoint is accessible within the VPC."
  type        = bool
  default     = true
}

variable "enable_endpoint_public_access" {
  description = "Indicates whether the cluster API server endpoint is publicly accessible."
  type        = bool
}

# access_config
variable "authentication_mode" {
  description = "The authentication mode for the cluster."
  type        = string
  default     = "API_AND_CONFIG_MAP"
  validation {
    condition     = contains(["CONFIG_MAP", "API", "API_AND_CONFIG_MAP", null], var.authentication_mode)
    error_message = "The value of authentication_mode must be CONFIG_MAP, API, API_AND_CONFIG_MAP or null."
  }
}

variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Whether or not to bootstrap the access config values to the cluster."
  type        = bool
  default     = true
}

# upgrade_policy
variable "support_type" {
  description = "The support type for the EKS cluster upgrade policy."
  type        = string
  validation {
    condition     = contains(["STANDARD", "EXTENDED"], var.support_type)
    error_message = "The support_type must be one of the following: STANDARD, EXTENDED."
  }
}
