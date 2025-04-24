# RDS Security Group
# ===================================
resource "aws_security_group" "this" {
  name        = "${var.name}-security-group"
  description = "Allow traffic for Database"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.db_ingress_ports
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      security_groups = ingress.value.security_groups
    }
  }
  dynamic "egress" {
    for_each = var.db_egress_ports
    content {
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks
      security_groups = egress.value.security_groups
    }
  }
}

# RDS Subnet Group
# ===================================
resource "aws_db_subnet_group" "this" {
  name        = "${var.name}-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "Database subnet group for ${var.name}-subnet-group"
  tags        = merge(var.tags, { "Name" = "${var.name}-subnet-group" })
}

# PostgreSQL RDS
# ===================================
resource "aws_db_instance" "this" {
  identifier                 = var.name
  db_name                    = var.db_name
  instance_class             = var.instance_class
  db_subnet_group_name       = aws_db_subnet_group.this.name
  engine                     = "postgres"
  engine_version             = var.engine_version
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately
  deletion_protection        = var.deletion_protection
  vpc_security_group_ids     = [aws_security_group.this.id]
  multi_az                   = var.multi_az # Disable Multi-AZ, set to true for high availability
  username                   = var.username
  password                   = var.password
  publicly_accessible        = var.publicly_accessible # Private DB instance, change to true if public access is needed
  allocated_storage          = var.allocated_storage
  max_allocated_storage      = var.max_allocated_storage
  storage_type               = var.storage_type
  iops = (
    (var.storage_type == "io1" || var.storage_type == "io2" || var.storage_type == "gp3") &&
    var.allocated_storage >= 400
  ) ? var.iops : null
  storage_encrypted                     = var.storage_encrypted       # True or False
  backup_window                         = var.backup_window           # Retain backups for 7 days
  backup_retention_period               = var.backup_retention_period # Daily backup window
  maintenance_window                    = var.maintenance_window      # ddd:hh24:mi-ddd:hh24:mi". Ex: "Mon:00:00-Mon:03:00"
  delete_automated_backups              = var.delete_automated_backups
  skip_final_snapshot                   = var.skip_final_snapshot # True = disabled, Determines whether a final DB snapshot is created before the DB instance is deleted
  copy_tags_to_snapshot                 = true
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  monitoring_interval                   = var.monitoring_interval # 60  Enhanced monitoring (in seconds, set to 0 to disable) Valid Values: 0, 1, 5, 10, 15, 30, 60
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period # 7 Retain Performance Insights for 7 days
  tags                                  = merge(var.tags, { "Name" = var.name })
  lifecycle {
    ignore_changes = [
      engine_version,
      allocated_storage,
    ]
  }
}
