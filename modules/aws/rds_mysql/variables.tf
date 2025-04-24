# RDS Security Group
# ===================================
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the RDS instance will be deployed."
}

variable "db_ingress_ports" {
  type = set(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    security_groups = list(string)
  }))
  description = "Set of ingress rules for the RDS security group."
}

variable "db_egress_ports" {
  type = set(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    security_groups = list(string)
  }))
  description = "Set of egress rules for the RDS security group."
}

# RDS Subnet Group
# ===================================
variable "subnet_ids" {
  type        = set(string)
  description = "Set of private subnet IDs where the RDS instance will be deployed."
  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "At least one subnet ID must be provided."
  }
}

# MySQL RDS
# ===================================
variable "name" {
  type        = string
  description = "The name of the RDS instance."
}

variable "db_name" {
  type        = string
  description = "The initial database name for the RDS instance."
}

variable "instance_class" {
  type        = string
  description = "The instance type for the RDS database (e.g., db.t3.medium)."
}

variable "engine_version" {
  type        = string
  description = "The version of the database engine (e.g., 16.3)."
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Whether to automatically apply minor version upgrades to the database."
}

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Apply changes immediately (can cause downtime)."
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Enable deletion protection for the RDS instance."
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "Enable Multi-AZ for high availability."
}

variable "username" {
  type        = string
  description = "The master username for the database."
}

variable "password" {
  type        = string
  description = "The master password for the database."
  validation {
    condition     = length(var.password) >= 8
    error_message = "Password must be at least 8 characters long."
  }
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Whether the database is publicly accessible."
}

variable "allocated_storage" {
  type        = number
  description = "The allocated storage for the RDS instance (in GB)."
}

variable "max_allocated_storage" {
  type        = number
  description = "The maximum storage for the database when auto-scaling is enabled."
  validation {
    condition     = var.max_allocated_storage > var.allocated_storage
    error_message = "Max allocated storage must be greater than allocated storage."
  }
}

variable "storage_type" {
  type        = string
  description = "The storage type for the database (e.g., gp2, io1, gp3)."
}

variable "iops" {
  type        = number
  default     = 3000
  description = "IOPS for the database storage (minimum: 3000, maximum: 16000 for gp3 volumes)."
}

variable "storage_encrypted" {
  type        = bool
  default     = true
  description = "Enable storage encryption for the database."
}

variable "backup_window" {
  type        = string
  default     = "03:00-04:00"
  description = "The daily time range for automated backups (hh24:mi-hh24:mi)."
}

variable "backup_retention_period" {
  type        = number
  default     = 30
  description = "The number of days to retain backups"
  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 1 and 35 days."
  }
}

variable "maintenance_window" {
  type        = string
  default     = "Tue:00:00-Tue:03:00"
  description = "The weekly maintenance window for the database (ddd:hh24:mi-ddd:hh24:mi)."
}

variable "delete_automated_backups" {
  type        = bool
  default     = false
  description = "Delete automated backups when the RDS instance is deleted."
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip the final snapshot when the RDS instance is deleted."
}

variable "enabled_cloudwatch_logs_exports" {
  type        = set(string)
  default     = ["error", "slowquery"]
  description = "Database logs to export to CloudWatch."
}

variable "monitoring_interval" {
  type        = number
  default     = 60
  description = "Enhanced monitoring (in seconds, set to 0 to disable) Valid Values: 0, 1, 5, 10, 15, 30, 60."
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to resources"
}
