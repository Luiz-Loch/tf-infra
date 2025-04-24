# ALB Security Group
# ===================================
output "security_group_id" {
  description = "ID of the security group created for the Load Balancer"
  value       = aws_security_group.this.id
}

# Application Load Balancer
# ===================================
output "alb_arn" {
  description = "ARN of the created Application Load Balancer"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "DNS name of the Load Balancer"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Load Balancer for Route 53 configuration"
  value       = aws_lb.this.zone_id
}

# Load Balancer Target Groups
# ===================================
output "target_group_arns" {
  description = "Map of target group names to ARNs"
  value       = { for name, tg in aws_lb_target_group.this : name => tg.arn }
}

output "target_group_names" {
  description = "Map of target group names to their names in AWS"
  value       = { for name, tg in aws_lb_target_group.this : name => tg.name }
}

# Load Balancer listeners
# ===================================
output "http_listener_arns" {
  description = "ARNs of the HTTP listeners"
  value       = [for l in aws_lb_listener.http : l.arn]
}

output "https_listener_arns" {
  description = "ARNs of the HTTPS listeners (if enabled)"
  value       = var.enable_https_listener ? [for l in aws_lb_listener.https : l.arn] : []
}
