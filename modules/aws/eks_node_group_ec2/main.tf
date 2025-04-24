# IAM Role
# ===================================
resource "aws_iam_role" "this" {
  name        = "${var.node_group_name}-role"
  description = "IAM Role for EKS Node Group  ${var.node_group_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
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
# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSWorkerNodePolicy.html
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.this.name
}

# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEC2ContainerRegistryReadOnly.html
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.this.name
}

# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonSSMManagedInstanceCore.html
resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.this.name
}

# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/CloudWatchAgentServerPolicy.html
resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.this.name
}

# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AutoScalingFullAccess.html
resource "aws_iam_role_policy_attachment" "AutoScalingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.this.name
}

# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKS_CNI_Policy.html
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.this.name
}

# Security Group
# ===================================
resource "aws_security_group" "this" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for ${var.node_group_name} EKS Node Group"
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

# EKS -- Node Group
# ===================================
resource "aws_eks_node_group" "this" {
  node_group_name = var.node_group_name
  cluster_name    = var.cluster_name
  subnet_ids      = var.subnet_ids
  node_role_arn   = aws_iam_role.this.arn
  capacity_type   = var.capacity_type
  disk_size       = var.disk_size
  instance_types  = var.instance_type
  scaling_config {
    max_size     = var.max_size
    desired_size = var.desired_size
    min_size     = var.min_size
  }
  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
    # If specify this configuration, but do not specify `source_security_group_ids` when you create an EKS Node Group, either
    # port 3389 for Windows, or port 22 for all other operating systems is opened on the worker nodes to the Internet (0.0.0.0/0).
  }
  update_config {
    max_unavailable_percentage = var.max_unavailable_percentage
  }
  tags = var.tags
}
