# IAM Role
# ===================================
output "fargate_profile_role_arn" {
  description = "The ARN of the IAM role associated with the Fargate profile."
  value       = aws_iam_role.this.arn
}

# IAM Policy
# ===================================

# IAM Role Policy Attachment
# ===================================

# EKS Node Group
# ===================================
output "fargate_profile_name" {
  description = "The name of the EKS Fargate profile."
  value       = aws_eks_fargate_profile.this.fargate_profile_name
}

output "arn" {
  description = "The ARN of the EKS Fargate profile."
  value       = aws_eks_fargate_profile.this.arn
}

output "subnet_ids" {
  description = "The list of subnet IDs associated with the Fargate profile."
  value       = aws_eks_fargate_profile.this.subnet_ids
}

output "namespace" {
  description = "The Kubernetes namespace associated with the Fargate profile."
  value       = aws_eks_fargate_profile.this.selector[*].namespace
}