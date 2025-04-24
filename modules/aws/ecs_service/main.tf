# ECS Service
# ===================================
resource "aws_ecs_service" "this" {
  name                               = var.name
  cluster                            = var.cluster_arn
  task_definition                    = var.task_definition_arn
  desired_count                      = var.desired_count
  launch_type                        = var.launch_type
  platform_version                   = var.platform_version
  availability_zone_rebalancing      = var.availability_zone_rebalancing
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent

  network_configuration {
    subnets          = var.network_configuration.subnets
    security_groups  = var.network_configuration.security_groups
    assign_public_ip = var.network_configuration.assign_public_ip
  }

  load_balancer {
    container_name   = var.load_balancer.container_name
    container_port   = var.load_balancer.container_port
    target_group_arn = var.load_balancer.target_group_arn
  }

  enable_execute_command = var.enable_execute_command
  tags                   = var.tags
}
