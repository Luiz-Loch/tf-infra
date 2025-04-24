output "address" {
  value       = aws_db_instance.this.address
  description = "The hostname of the RDS instance."
}

output "db_name" {
  value       = aws_db_instance.this.db_name
  description = "The database name."
}

output "endpoint" {
  value       = aws_db_instance.this.endpoint
  description = "The endpoint of the MariaDB database instance."
}

output "username" {
  value       = aws_db_instance.this.username
  description = "The master username for the database."
}

output "port" {
  value       = aws_db_instance.this.port
  description = "The database port."
}
