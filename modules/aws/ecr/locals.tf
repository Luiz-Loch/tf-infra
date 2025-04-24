locals {
  retention_tag_prefix_rule = length(var.retention_tag_prefix) == 0 ? null : {
    rulePriority = 1
    description  = "Keep all images with tags starting with prefix ${var.retention_tag_prefix}"
    selection = {
      tagStatus     = "tagged"
      tagPrefixList = [var.retention_tag_prefix]
      countType     = "sinceImagePushed"
      countUnit     = "days"
      countNumber   = 3650 # Retain all images with release prefix for 10 years
    }
    action = {
      type = "expire"
    }
  }
  retention_period_days_rule = var.retention_period_days == 0 ? null : {
    rulePriority = 2
    description  = "Expire images not tagged with prefix after ${var.retention_period_days} days"
    selection = {
      tagStatus   = "any"
      countType   = "sinceImagePushed"
      countUnit   = "days"
      countNumber = var.retention_period_days # Expire images older than the specified retention period days
    }
    action = {
      type = "expire"
    }
  }
  rules = concat(
    local.retention_tag_prefix_rule == null ? [] : [local.retention_tag_prefix_rule],
    local.retention_period_days_rule == null ? [] : [local.retention_period_days_rule]
  )
}