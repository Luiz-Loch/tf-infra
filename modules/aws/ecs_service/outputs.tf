# ECS Service Outputs
# ===================================
output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "ecs_service_id" {
  description = "The ID of the ECS service"
  value       = aws_ecs_service.this.id
}

output "ecs_service_cluster_arn" {
  description = "The ARN of the ECS cluster the service is running on"
  value       = aws_ecs_service.this.cluster
}

output "ecs_service_task_definition" {
  description = "The task definition used by the ECS service"
  value       = aws_ecs_service.this.task_definition
}

output "ecs_service_load_balancer" {
  description = "The load balancer configuration associated with the ECS service"
  value       = aws_ecs_service.this.load_balancer
}
