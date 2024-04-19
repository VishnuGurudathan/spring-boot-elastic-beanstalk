################################################################################
# VPC                                                                          #
################################################################################
resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.tags,
    { "Name" : format("%s-vpc", local.resource_name_prefix) }
  )

}

################################################################################
# Internet Gateway
################################################################################
resource "aws_internet_gateway" "this" {
  count = local.create_public_subnets && var.create_igw ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    var.tags,
    { "Name" : format("%s-igw", local.resource_name_prefix) }
  )
}


data "aws_availability_zones" "available" {
  state = "available"
}

################################################################################
# Publiс Subnets
################################################################################
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : var.public_subnet_count

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = length(var.public_subnets) > 0 ? element(var.public_subnets, count.index) : cidrsubnet(local.subnet_bits, 4, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(
    var.tags,
    { "Name" : format("%s-public-%d", local.resource_name_prefix, count.index) },
    var.public_subnet_tags
  )
}

################################################################################
# Private Subnets
################################################################################
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : var.private_subnet_count

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = cidrsubnet(local.subnet_bits, 4, count.index + 4) # Use dynamic CIDR calculation
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(
    var.tags,
    { "Name" : format("%s-private-%d", local.resource_name_prefix, count.index) },
    var.private_subnet_tags
  )
}

resource "aws_subnet" "db_subnets" {
  count = length(var.db_subnets) > 0 ? length(var.db_subnets) : var.db_subnet_count

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = cidrsubnet(local.subnet_bits, 4, count.index + 8) # Use dynamic CIDR calculation
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(
    var.tags,
    { "Name" : format("%s-db-%d", local.resource_name_prefix, count.index) },
    var.private_subnet_tags
  )
}

resource "aws_subnet" "redis_subnets" {
  count = length(var.redis_subnets) > 0 ? length(var.redis_subnets) : var.redis_subnet_count

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = cidrsubnet(local.subnet_bits, 4, count.index + 10) # Use dynamic CIDR calculation
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(
    var.tags,
    { "Name" : format("%s-cache-%d", local.resource_name_prefix, count.index) },
    var.private_subnet_tags
  )
}
################################################################################
# Elastic IP Address
################################################################################
resource "aws_eip" "this" {
  count = local.create_vpc ? 1 : 0

  domain = "vpc"

  tags = merge(
    { "Name" : format("%s-eip", local.resource_name_prefix) },
    var.tags
  )

  depends_on = [aws_internet_gateway.this]
}

################################################################################
# NAT Gateway 
################################################################################
resource "aws_nat_gateway" "this" {
  #  count = local.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0
  count = local.create_vpc ? 1 : 0

  allocation_id = element(aws_eip.this.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  depends_on = [aws_internet_gateway.this]

  tags = merge(
    var.tags,
    { "Name" : format("%s-ngw", local.resource_name_prefix) }
  )
}

################################################################################
# Route table association
################################################################################
resource "aws_route_table" "public_route_table" {
  #  count  = length(var.public_subnets) > 0 ? length(var.public_subnets) : var.public_subnet_count
  count  = var.public_subnet_count > 0 ? 1 : 0
  vpc_id = aws_vpc.this[0].id
  route {
    cidr_block = local.public_route_cidr_block
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(
    var.tags,
    { "Name" : format("%s-pub-rt-%d", local.resource_name_prefix, count.index) }
  )
}

resource "aws_route_table_association" "public_association" {
  #count = length(var.public_subnets) > 0 ? length(var.public_subnets) : var.public_subnet_count
  count = length(aws_subnet.public_subnets[*].id)

  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index) # Use the provided public_subnets list or generate the subnet ID using count.index
  route_table_id = aws_route_table.public_route_table[0].id

  #tags = var.tags
}
resource "aws_route_table" "private_route_table" {
  count = var.private_subnet_count > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id
  route {
    cidr_block = local.public_route_cidr_block
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = merge(
    var.tags,
    { "Name" : format("%s-pvt-rt-%d", local.resource_name_prefix, count.index) }
  )
}

resource "aws_route_table_association" "private_association" {
  count = length(aws_subnet.private_subnets[*].id)

  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route_table[0].id
}

resource "aws_route_table" "db_route_table" {
  count = var.db_subnet_count > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    var.tags,
    { "Name" : format("%s-db-rt-%d", local.resource_name_prefix, count.index) }
  )
}

resource "aws_route_table_association" "db_association" {
  count = length(aws_subnet.db_subnets[*].id)

  subnet_id      = element(aws_subnet.db_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route_table[0].id
}

resource "aws_route_table_association" "cache_association" {
  count = length(aws_subnet.redis_subnets[*].id)

  subnet_id      = element(aws_subnet.redis_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route_table[0].id
}

#resource "aws_internet_gateway" "this" {
#  vpc_id = aws_vpc.this.id
#}
// TODO : need to refactor subnet like bellow
#module "public_subnets" {
#  source = "../../modules/subnets"
#
#  vpc_id = aws_vpc.main.id
#  subnet_count = 2
#  public = true
#}
#
#module "private_subnets" {
#  source = "../../modules/subnets"
#
#  vpc_id = aws_vpc.main.id
#  subnet_count = 2
#  public = false
#}
#module "igw" {
#  source = "./igw"
#  vpc_id = aws_vpc.this.id
#}
#module "subnet" {
#  source = "./subnet-todo"
#
#  vpc_id = aws_vpc.this.id
#  igw_id =
#  public_subnets = 2
#  subnet_count   = 4
#}
#
#
#module "nat_gateways" {
#  source = "./nat_gateways"
#
#  public_subnet_ids = module.subnet.
#}