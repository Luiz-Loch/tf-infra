# IAM Role
# ===================================
resource "aws_iam_role" "this" {
  name        = "${var.fargate_profile_name}-role"
  description = "IAM Role for EKS Fargate ${var.fargate_profile_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })
  tags = var.tags
}

# IAM Policy
# ===================================

# IAM Role Policy Attachment
# ===================================

# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSFargatePodExecutionRolePolicy.html
resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.this.name
}

# EKS -- Node Group
# ===================================
resource "aws_eks_fargate_profile" "this" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = var.fargate_profile_name
  pod_execution_role_arn = aws_iam_role.this.arn
  subnet_ids             = var.subnet_ids
  selector {
    namespace = var.namespace
  }
  tags = var.tags
}
