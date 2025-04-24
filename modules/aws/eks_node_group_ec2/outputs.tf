# IAM Role
# ===================================
output "node_group_iam_role_name" {
  description = "The IAM role name for the EKS Node Group"
  value       = aws_iam_role.this.name
}

output "node_group_iam_role_arn" {
  description = "The IAM role ARN for the EKS Node Group"
  value       = aws_iam_role.this.arn
}

# IAM Policy
# ===================================

# IAM Role Policy Attachment
# ===================================

# Security Group
# ===================================
output "node_group_security_group_id" {
  description = "The ID of the security group for the EKS Node Group"
  value       = aws_security_group.this.id
}

output "node_group_security_group_name" {
  description = "The name of the security group for the EKS Node Group"
  value       = aws_security_group.this.name
}

# EKS -- Node Group
# ===================================
output "id" {
  description = "The ID of the EKS Node Group"
  value       = aws_eks_node_group.this.id
}

output "arn" {
  description = "The ARN of the EKS Node Group"
  value       = aws_eks_node_group.this.arn
}

output "capacity_type" {
  description = "The capacity type of the EKS Node Group"
  value       = aws_eks_node_group.this.capacity_type
}

output "instance_types" {
  description = "The instance types for the EKS Node Group"
  value       = aws_eks_node_group.this.instance_types
}

output "subnet_ids" {
  description = "The subnet IDs associated with the EKS Node Group"
  value       = aws_eks_node_group.this.subnet_ids
}

output "scaling_config" {
  description = "The scaling configuration for the EKS Node Group"
  value       = aws_eks_node_group.this.scaling_config
}

output "ec2_ssh_key" {
  description = "The EC2 SSH key for remote access to the EKS Node Group"
  value       = aws_eks_node_group.this.remote_access[0].ec2_ssh_key
}

output "update_config" {
  description = "The update configuration for the EKS Node Group"
  value       = aws_eks_node_group.this.update_config
}