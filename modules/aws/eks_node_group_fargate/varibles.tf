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
variable "cluster_iam_role_name" {
  description = "The name of the IAM role associated with the EKS cluster."
  type = string
}

# EKS Node Group
# ===================================
variable "fargate_profile_name" {
  description = "The name of the EKS Fargate profile."
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the EKS Node Group."
  type        = list(string)
}

# selector
variable "namespace" {
  description = "The Kubernetes namespace where this Fargate profile should apply. Only pods in this namespace will run on Fargate."
  type        = string
  default     = "default"
}
