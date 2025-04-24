module "cluster" {
  source = "../../modules/aws/ecs_cluster"
  name   = "${local.name}-cluster"
  tags   = local.tags
}

module "nginx_task_definition" {
  source = "../../modules/aws/ecs_task_definition"

  name   = "${local.name}-nginx"
  region = local.region

  cpu    = "256"
  memory = "512"

  container_definitions = [
    {
      name      = "nginx"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true

      environment = []

      port_mappings = [
        {
          container_port = 80
          host_port      = 80
          protocol       = "tcp"
        }
      ]
    }
  ]

  tags = local.tags
}

module "servico_01_task_definition" {
  source = "../../modules/aws/ecs_task_definition"

  name   = "${local.name}-servico01"
  region = local.region

  cpu    = "256"
  memory = "512"

  cpu_architecture = "ARM64"

  container_definitions = [
    {
      name      = "servico_01"
      image     = module.servico_01.repository_url
      cpu       = 256
      memory    = 512
      essential = true

      environment = []

      port_mappings = [
        {
          container_port = 80
          host_port      = 80
          protocol       = "tcp"
        }
      ]
    }
  ]

  tags = local.tags
}

module "servico_02_task_definition" {
  source = "../../modules/aws/ecs_task_definition"

  name   = "${local.name}-servico02"
  region = local.region

  cpu    = "256"
  memory = "512"

  cpu_architecture = "ARM64"

  container_definitions = [
    {
      name      = "servico_02"
      image     = module.servico_02.repository_url
      cpu       = 256
      memory    = 512
      essential = true

      environment = []

      port_mappings = [
        {
          container_port = 80
          host_port      = 80
          protocol       = "tcp"
        }
      ]
    }
  ]

  tags = local.tags
}

module "load_balancer" {
  source                = "../../modules/aws/load_balancer"
  name                  = "${local.name}-ecs-lb"
  vpc_id                = module.vpc.id
  subnets               = [module.vpc_subnet_1_public.id, module.vpc_subnet_2_public.id]
  enable_https_listener = false
  ingress_ports = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_ports = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  target_groups = {
    "root" = {
      load_balancing_algorithm_type = "round_robin"
      port                          = 80
      path                          = "/"
      protocol                      = "HTTP"
      target_type                   = "ip"
      health_check = {
        enabled             = true
        healthy_threshold   = 3
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        timeout             = 10
        unhealthy_threshold = 3
      }
    },
    "servico-01" = {
      load_balancing_algorithm_type = "round_robin"
      port                          = 80
      path                          = "/servico_01.json"
      protocol                      = "HTTP"
      target_type                   = "ip"
      health_check = {
        enabled             = true
        healthy_threshold   = 3
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        timeout             = 10
        unhealthy_threshold = 3
      }
    },
    "servico-02" = {
      load_balancing_algorithm_type = "round_robin"
      port                          = 80
      path                          = "/servico_02.json"
      protocol                      = "HTTP"
      target_type                   = "ip"
      health_check = {
        enabled             = true
        healthy_threshold   = 3
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        timeout             = 10
        unhealthy_threshold = 3
      }
    }
  }

  tags = local.tags
}

resource "aws_security_group" "ecs_service_sg" {
  name   = "${local.name}-ecs-sg"
  vpc_id = module.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [module.load_balancer.security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "service_root" {
  source              = "../../modules/aws/ecs_service"
  name                = "${local.name}-nginx-service"
  cluster_arn         = module.cluster.cluster_id
  task_definition_arn = module.nginx_task_definition.task_definition_arn
  desired_count       = 2
  launch_type         = "FARGATE"
  network_configuration = {
    subnets          = [module.vpc_subnet_1_private.id, module.vpc_subnet_2_private.id]
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = false
  }
  load_balancer = {
    target_group_arn = module.load_balancer.target_group_arns["root"]
    container_name   = "nginx"
    container_port   = 80
  }
  tags = local.tags
}

module "service_servico_01" {
  source              = "../../modules/aws/ecs_service"
  name                = "${local.name}-service-01"
  cluster_arn         = module.cluster.cluster_id
  task_definition_arn = module.servico_01_task_definition.task_definition_arn
  desired_count       = 1
  launch_type         = "FARGATE"
  network_configuration = {
    subnets          = [module.vpc_subnet_1_private.id, module.vpc_subnet_2_private.id]
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = false
  }
  load_balancer = {
    target_group_arn = module.load_balancer.target_group_arns["servico-01"]
    container_name   = "servico_01"
    container_port   = 80
  }
  tags = local.tags
}

module "service_servico_02" {
  source              = "../../modules/aws/ecs_service"
  name                = "${local.name}-service-02"
  cluster_arn         = module.cluster.cluster_id
  task_definition_arn = module.servico_02_task_definition.task_definition_arn
  desired_count       = 1
  launch_type         = "FARGATE"
  network_configuration = {
    subnets          = [module.vpc_subnet_1_private.id, module.vpc_subnet_2_private.id]
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = false
  }
  load_balancer = {
    target_group_arn = module.load_balancer.target_group_arns["servico-02"]
    container_name   = "servico_02"
    container_port   = 80
  }
  tags = local.tags
}
