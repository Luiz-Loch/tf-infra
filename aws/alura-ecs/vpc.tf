# VPC
# ===================================================
module "vpc" {
  source               = "../../modules/aws/vpc"
  name                 = "${local.name}-vpc"
  cidr_block           = "10.1.0.0/16" # 65,536 IPs available
  enable_dns_hostnames = false
  tags                 = local.tags
}

# Public subnets
# ===================================================
module "vpc_subnet_1_public" {
  source                  = "../../modules/aws/vpc_subnet"
  vpc_id                  = module.vpc.id
  name                    = "${local.name}-subnet-1-public"
  cidr_block              = "10.1.0.0/24" # 256 IPs available
  availability_zone       = "${local.region}a"
  map_public_ip_on_launch = true
  tags                    = local.tags
}

module "vpc_subnet_2_public" {
  source                  = "../../modules/aws/vpc_subnet"
  vpc_id                  = module.vpc.id
  name                    = "${local.name}-subnet-2-public"
  cidr_block              = "10.1.1.0/24" # 256 IPs available
  availability_zone       = "${local.region}b"
  map_public_ip_on_launch = true
  tags                    = local.tags
}

# Private subnets
# ===================================================
module "vpc_subnet_1_private" {
  source                  = "../../modules/aws/vpc_subnet"
  vpc_id                  = module.vpc.id
  name                    = "${local.name}-subnet-1-private"
  cidr_block              = "10.1.16.0/20" # 4,096 IPs available
  availability_zone       = "${local.region}a"
  map_public_ip_on_launch = false
  tags                    = local.tags
}

module "vpc_subnet_2_private" {
  source                  = "../../modules/aws/vpc_subnet"
  vpc_id                  = module.vpc.id
  name                    = "${local.name}-subnet-2-private"
  cidr_block              = "10.1.32.0/20" # 4,096 IPs available
  availability_zone       = "${local.region}b"
  map_public_ip_on_launch = false
  tags                    = local.tags
}

# Internet Gateway
# ===================================================
module "vpc_internet_gateway" {
  source = "../../modules/aws/vpc_internet_gateway"
  vpc_id = module.vpc.id
  name   = "${local.name}-internet-gateway"
  tags   = local.tags
}

# NAT Gateway
# ===================================================
module "nat_gateway" {
  source           = "../../modules/aws/vpc_nat_gateway"
  public_subnet_id = module.vpc_subnet_1_public.id
  name             = "${local.name}-nat-gateway"
  tags             = local.tags
  depends_on       = [module.vpc_internet_gateway]
}

# Route tables
# ===================================================
module "vpc_route_table_public" {
  source     = "../../modules/aws/vpc_route_table"
  vpc_id     = module.vpc.id
  gateway_id = module.vpc_internet_gateway.id
  cidr_block = "0.0.0.0/0"
  name       = "${local.name}-route-table-public"
  subnets_ids = {
    "subnet-1-public" = module.vpc_subnet_1_public.id
    "subnet-2-public" = module.vpc_subnet_2_public.id
  }
  tags = local.tags
}

module "vpc_route_table_private" {
  source         = "../../modules/aws/vpc_route_table"
  vpc_id         = module.vpc.id
  nat_gateway_id = module.nat_gateway.id
  cidr_block     = "0.0.0.0/0"
  name           = "${local.name}-route-table-private"
  subnets_ids = {
    "subnet-1-private" = module.vpc_subnet_1_private.id
    "subnet-2-private" = module.vpc_subnet_2_private.id
  }
  tags = local.tags
}
