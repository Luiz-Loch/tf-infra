# ALB Security Group
# ===================================
resource "aws_security_group" "this" {
  name        = "${var.name}-alb-sg"
  description = "Security group for ${var.name} application load balancer"
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

# Application Load Balancer
# ===================================
resource "aws_lb" "this" {
  load_balancer_type         = "application"
  name                       = var.name
  internal                   = var.internal
  ip_address_type            = "ipv4"
  subnets                    = var.subnets
  security_groups            = [aws_security_group.this.id]
  enable_deletion_protection = var.enable_deletion_protection
  tags                       = var.tags
}

# Load Balancer Target Group
# ===================================
resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name                          = "${var.name}-${each.key}-tg"
  load_balancing_algorithm_type = each.value.load_balancing_algorithm_type
  port                          = each.value.port
  protocol                      = each.value.protocol
  vpc_id                        = var.vpc_id
  target_type                   = each.value.target_type

  health_check {
    enabled             = each.value.health_check.enabled
    healthy_threshold   = each.value.health_check.healthy_threshold
    interval            = each.value.health_check.interval
    path                = each.value.health_check.path
    port                = each.value.health_check.port
    timeout             = each.value.health_check.timeout
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
  }

  tags = var.tags
}

# Load Balancer listener
# ===================================
resource "aws_lb_listener" "http" {
  count             = var.enable_https_listener ? 0 : 1
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 Not Found"
      status_code  = "404"
    }
  }

  tags = var.tags
}

resource "aws_lb_listener_rule" "http_path_routing" {
  for_each = var.enable_https_listener ? {} : var.target_groups

  listener_arn = aws_lb_listener.http[0].arn
  priority     = 100 + index(keys(var.target_groups), each.key)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.path]
    }
  }

  tags = var.tags
}

resource "aws_lb_listener" "https" {
  count             = var.enable_https_listener ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 Not Found"
      status_code  = "404"
    }
  }

  tags = var.tags
}

resource "aws_lb_listener_rule" "https_path_routing" {
  for_each = var.enable_https_listener ? var.target_groups : {}

  listener_arn = aws_lb_listener.https[0].arn
  priority     = 200 + index(keys(var.target_groups), each.key)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.path]
    }
  }

  tags = var.tags
}
