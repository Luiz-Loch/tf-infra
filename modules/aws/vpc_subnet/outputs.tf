output "id" {
  description = "The ID of the subnet"
  value       = aws_subnet.this.id
}

output "arn" {
  description = "The ARN of the subnet"
  value       = aws_subnet.this.arn
}

output "cidr_block" {
  description = "The CIDR block of the subnet"
  value       = aws_subnet.this.cidr_block
}

output "availability_zone" {
  description = "The availability zone of the subnet"
  value       = aws_subnet.this.availability_zone
}
