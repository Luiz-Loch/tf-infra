# Elastic IP
# ===================================
resource "aws_eip" "this" {
  domain = var.elastic_ip_domain
  tags   = merge(var.tags, { "Name" = var.name })
}

# NAT Gateway
# ===================================
# To ensure proper ordering, it is recommended to add an explicit dependency
# on the Internet Gateway for the VPC.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = var.public_subnet_id
  tags          = merge(var.tags, { "Name" = var.name })
}
