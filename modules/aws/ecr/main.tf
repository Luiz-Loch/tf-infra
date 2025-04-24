# ECR Repository
# ===================================
resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  force_delete = var.force_delete
  tags         = var.tags
}

# ECR Repository Lifecycle Policy
# ===================================
resource "aws_ecr_lifecycle_policy" "this" {
  count      = length(var.retention_tag_prefix) > 0 || var.retention_period_days > 0 ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy = jsonencode({
    rules = local.rules
  })
}
