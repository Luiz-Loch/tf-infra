# ECS Task Definition
# ===================================
output "task_definition_arn" {
  description = "ARN of the ECS Task Definition"
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "Family name of the ECS Task Definition"
  value       = aws_ecs_task_definition.this.family
}

# CloudWatch Log Group
# ===================================
output "log_group_name" {
  description = "Name of the CloudWatch Log Group used by the containers"
  value       = aws_cloudwatch_log_group.this.name
}

# IAM Role
# ===================================
output "execution_role_arn" {
  description = "ARN of the ECS Task Execution Role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "task_role_arn" {
  description = "ARN of the ECS Task Role"
  value       = aws_iam_role.ecs_task_role.arn
}

