# Elastic IP
# ===================================

# NAT Gateway
# ===================================
output "public_ip" {
  description = "The public IP of the NAT Gateway"
  value       = aws_nat_gateway.this.public_ip
}

output "id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.this.id
}
