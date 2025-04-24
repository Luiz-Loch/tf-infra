# ECS Task Definition
# ===================================
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name}-task-definition"
  requires_compatibilities = var.launch_type

  runtime_platform {
    cpu_architecture        = var.cpu_architecture
    operating_system_family = var.operating_system_family
  }

  network_mode       = var.network_mode
  cpu                = var.cpu
  memory             = var.memory
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    for container in var.container_definitions : {
      name      = container.name
      image     = container.image
      essential = container.essential

      portMappings = [
        for port_mapping in container.port_mappings : {
          containerPort = port_mapping.container_port
          protocol      = port_mapping.protocol
          hostPort      = port_mapping.host_port
        }
      ]

      cpu    = container.cpu
      memory = container.memory

      environment = [
        for env in container.environment : {
          name  = env.name
          value = env.value
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.this.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = container.name
        }
      }
    }
  ])

  ephemeral_storage {
    size_in_gib = var.ephemeral_storage_size
  }

  tags = var.tags
}

# CloudWatch Log Group
# ===================================
resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/task-definition/${var.name}"
  retention_in_days = var.log_retention_in_days
  tags              = var.tags
}
