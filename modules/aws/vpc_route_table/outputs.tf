# Route Table
# ===================================
output "id" {
  description = "The ID of the route table"
  value       = aws_route_table.this.id
}

output "arn" {
  description = "The ARN of the route table"
  value       = aws_route_table.this.arn
}

# Route Table Association
# ===================================