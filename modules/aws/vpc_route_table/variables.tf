variable "tags" {
  description = "Additional tags for the route table"
  type        = map(string)
}

variable "name" {
  description = "The name of the route table"
  type        = string
}

# Route Table
# ===================================
variable "vpc_id" {
  description = "The VPC ID to associate the route table with"
  type        = string
}

variable "cidr_block" {
  type = string
}

variable "gateway_id" {
  description = "The ID of the Internet Gateway for public subnet routing"
  type        = string
  default     = null
}

variable "nat_gateway_id" {
  description = "The ID of the NAT Gateway for private subnet routing"
  type        = string
  default     = null
}

# Route Table Association
# ===================================

variable "subnets_ids" {
  description = "Map of subnet IDs to associate with the route table"
  type        = map(string)
}