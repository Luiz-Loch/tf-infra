# EC2 Security Group
# ===================================
resource "aws_security_group" "this" {
  name        = "${var.name}-ec2-sg"
  description = "Security group for ${var.name} EC2 instance"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.egress_ports
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = var.tags
}

# IAM Role
# ===================================
resource "aws_iam_role" "this" {
  name = "${var.name}-ec2-role"
  description = "IAM Role for EC2 ${var.name}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}

# IAM Policy
# ===================================
resource "aws_iam_policy" "this" {
  name        = "${var.name}-policy"
  description = "Policy to allow some S3 actions."
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetBucketLocation",
        ],
        "Resource" : "*"
      }
    ]
  })
  tags = var.tags
}

# IAM Role Policy Attachment
# ===================================
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}


# IAM Instance Profile
# ===================================
resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-ec2-profile"
  role = aws_iam_role.this.name
  tags = var.tags
}

# IAM Instance
# ===================================
resource "aws_instance" "this" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.this.name
  monitoring             = var.monitoring
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = var.delete_on_termination
    tags                  = merge(var.tags, { "Name" = var.name })
  }
  tags = merge(var.tags, { "Name" = var.name })
  lifecycle {
    ignore_changes = [ami]
  }
  user_data = var.user_data
}

# EC2 Elastic IP
# ===================================
resource "aws_eip" "this" {
  count    = var.elastic_ip ? 1 : 0
  domain   = var.elastic_ip_domain
  instance = aws_instance.this.id
  tags     = merge(var.tags, { "Name" = var.name })
}