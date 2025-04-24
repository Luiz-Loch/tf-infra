# IAM Role
# ===================================
resource "aws_iam_role" "this" {
  name        = "${var.name}-cluster-role"
  description = "IAM Role for EKS cluster ${var.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
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
# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSClusterPolicy.html
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.this.name
}

# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSServicePolicy.html
resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.this.name
}

# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSVPCResourceController.html
resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.this.name
}

# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/CloudWatchLogsFullAccess.html
resource "aws_iam_role_policy_attachment" "CloudWatchLogsFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.this.name
}

# https://docs.aws.amazon.com/pt_br/aws-managed-policy/latest/reference/AmazonEKSForFargateServiceRolePolicy.html
resource "aws_iam_role_policy_attachment" "AmazonEKSForFargateServiceRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonEKSForFargateServiceRolePolicy"
  role       = aws_iam_role.this.name
}

# Security Group
# ===================================
resource "aws_security_group" "this" {
  name        = "${var.name}-cluster-sg"
  description = "Security group for ${var.name} EKS cluster"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = local.merged_ingress_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = local.merged_egress_ports
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = var.tags
}

# EKS -- Control Plane
# ===================================
resource "aws_eks_cluster" "this" {
  name                      = var.name
  version                   = var.kubernetes_version
  role_arn                  = aws_iam_role.this.arn
  enabled_cluster_log_types = var.enabled_cluster_log_types
  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.enable_endpoint_public_access
    security_group_ids      = [aws_security_group.this.id]
  }
  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }
  upgrade_policy {
    support_type = var.support_type
  }
  tags = var.tags
}
