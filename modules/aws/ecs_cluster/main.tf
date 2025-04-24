# ECS Cluster
# ===================================
resource "aws_ecs_cluster" "this" {
  name = var.name

  configuration {
    execute_command_configuration {
      # kms_key_id = aws_kms_key.this.key_id
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = false
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.this.name
      }
    }
  }

  setting {
    name  = "containerInsights"
    value = var.container_insights
  }

  tags = var.tags
}


# CloudWatch Log Group
# ===================================
resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/cluster/${var.name}"
  retention_in_days = var.log_retention_in_days
  tags              = var.tags
}

# KMS Key
# ===================================
# resource "aws_kms_key" "this" {

#   description         = "KMS key for ECS ${var.name} CloudWatch log encryption"
#   enable_key_rotation = true

#   tags = merge(
#     var.tags,
#     {
#       Name = "${var.name}-kms-key"
#     }
#   )
# }
