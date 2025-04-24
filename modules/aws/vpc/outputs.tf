output "id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.this.id
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "default_security_group_id" {
  description = "The ID of the default security group for the VPC"
  value       = aws_vpc.this.default_security_group_id
}

output "default_route_table_id" {
  description = "The ID of the main route table associated with the VPC"
  value       = aws_vpc.this.main_route_table_id
}

output "enable_dns_hostnames" {
  description = "Indicates if DNS hostnames are enabled for the VPC"
  value       = aws_vpc.this.enable_dns_hostnames
}
