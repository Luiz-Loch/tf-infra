# Route Table
# ===================================
resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = var.cidr_block
    gateway_id     = var.gateway_id
    nat_gateway_id = var.nat_gateway_id
  }
  tags = merge(var.tags, { "Name" = var.name })
}

# Route Table Association
# ===================================
# Associate Subnets with the Route Table
resource "aws_route_table_association" "this" {
  for_each = var.subnets_ids

  subnet_id      = each.value
  route_table_id = aws_route_table.this.id
}
