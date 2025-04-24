# IAM Role
# ===================================
output "iam_role_arn" {
  description = "The ARN of the IAM role associated with the EKS cluster."
  value       = aws_iam_role.this.arn
}

output "iam_role_name" {
  description = "The name of the IAM role associated with the EKS cluster."
  value       = aws_iam_role.this.name
}

# IAM Policy
# ===================================

# IAM Role Policy Attachment
# ===================================

# Security Group
# ===================================
output "security_group_id" {
  description = "The ID of the security group associated with the EC2 instance."
  value       = aws_security_group.this.id
}

# EKS
# ===================================
output "name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "id" {
  description = "The ID of the EKS cluster."
  value       = aws_eks_cluster.this.id
}

output "arn" {
  description = "The ARN of the EKS cluster."
  value       = aws_eks_cluster.this.arn
}

output "endpoint" {
  description = "The endpoint for the EKS cluster."
  value       = aws_eks_cluster.this.endpoint
}

output "version" {
  description = "The Kubernetes version of the EKS cluster."
  value       = aws_eks_cluster.this.version
}

output "certificate_authority" {
  description = "The base64 encoded certificate data required to communicate with the cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}
