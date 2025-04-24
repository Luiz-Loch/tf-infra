# Instance Outputs
output "instance_id" {
  description = "The ID of the created EC2 instance."
  value       = aws_instance.this.id
}

output "instance_public_ip" {
  description = "The public IP address assigned to the EC2 instance. This will be null if the instance does not have a public IP."
  value       = aws_instance.this.public_ip
}

output "instance_private_ip" {
  description = "The private IP address assigned to the EC2 instance."
  value       = aws_instance.this.private_ip
}

# Elastic IP Outputs (Handles case where Elastic IP is disabled)
output "public_ip" {
  description = "The Elastic IP assigned to the instance, if enabled. If elastic_ip is false, this will be null."
  value       = try(aws_eip.this[0].public_ip, null)
}

# Security Group Outputs
output "security_group_id" {
  description = "The ID of the security group associated with the EC2 instance."
  value       = aws_security_group.this.id
}

# IAM Outputs
output "iam_role_name" {
  description = "The name of the IAM Role attached to the EC2 instance."
  value       = aws_iam_role.this.name
}

output "iam_instance_profile_name" {
  description = "The name of the IAM Instance Profile attached to the EC2 instance."
  value       = aws_iam_instance_profile.this.name
}
