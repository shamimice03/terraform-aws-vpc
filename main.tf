locals {
  vpc_id         = try(aws_vpc.this_vpc[0].id, null)
  nat_count      = var.create && var.enable_single_nat_gateway && length(var.public_subnet_cidr) > 0 ? 1 : 0
  create_public  = var.create && length(var.public_subnet_cidr) > 0
  create_private = var.create && length(var.private_subnet_cidr) > 0
  create_intra   = var.create && length(var.intra_subnet_cidr) > 0
  create_db      = var.create && length(var.db_subnet_cidr) > 0
}

############################################################################
###                           VPC                                        ###
############################################################################
resource "aws_vpc" "this_vpc" {
  count                = var.create ? 1 : 0
  cidr_block           = var.cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge({ "Name" = var.vpc_name }, var.tags)
}

############################################################################
###                          Public Subnet                               ###
############################################################################
resource "aws_subnet" "public" {
  count                   = local.create_public ? length(var.public_subnet_cidr) : 0
  vpc_id                  = local.vpc_id
  availability_zone       = var.azs[count.index]
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true


  tags = merge(
    { "Name" = "${var.vpc_name}-public-subnet-${count.index + 1}" },
    var.tags
  )
}

############################################################################
###                           Private Subnet                             ###
############################################################################
resource "aws_subnet" "private" {
  count             = local.create_private ? length(var.private_subnet_cidr) : 0
  vpc_id            = local.vpc_id
  availability_zone = var.azs[count.index]
  cidr_block        = var.private_subnet_cidr[count.index]


  tags = merge(
    { "Name" = "${var.vpc_name}-private-subnet-${count.index + 1}" },
    var.tags
  )
}

############################################################################
###                           Database Subnet                            ###
############################################################################
resource "aws_subnet" "db_subnet" {
  count             = local.create_db ? length(var.db_subnet_cidr) : 0
  vpc_id            = local.vpc_id
  availability_zone = var.azs[count.index]
  cidr_block        = var.db_subnet_cidr[count.index]


  tags = merge(
    { "Name" = "${var.vpc_name}-db-subnet-${count.index + 1}" },
    var.tags
  )
}

############################################################################
###                           Intra Subnet                            ###
############################################################################
resource "aws_subnet" "intra_subnet" {
  count             = local.create_intra ? length(var.intra_subnet_cidr) : 0
  vpc_id            = local.vpc_id
  availability_zone = var.azs[count.index]
  cidr_block        = var.intra_subnet_cidr[count.index]


  tags = merge(
    { "Name" = "${var.vpc_name}-intra-subnet-${count.index + 1}" },
    var.tags
  )
}

############################################################################
###                            Internet Gateway                          ###
############################################################################
resource "aws_internet_gateway" "igw" {
  count  = local.create_public ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = "${var.vpc_name}-igw" },
    var.tags
  )
}

############################################################################
###                      Route Table for Public Subnet                   ###
############################################################################
resource "aws_route_table" "public_route_table" {
  count  = local.create_public ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = "${var.vpc_name}-public-RT" },
    var.tags
  )
}

# Route Configuration for Public Subnets
resource "aws_route" "public_route_table_route" {
  count                  = local.create_public ? 1 : 0
  route_table_id         = aws_route_table.public_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

# Associate Public Subnets with the Public Route Table
resource "aws_route_table_association" "public_route_table_association" {
  count          = local.create_public ? length(var.public_subnet_cidr) : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route_table[0].id
}

############################################################################
###                              NAT GATEWAY                             ###
############################################################################

################################ SINGLE NAT ################################

# This configuration will deploy a single NAT gateway on the first public subnet

resource "aws_eip" "single_eip" {
  count  = local.nat_count
  domain = "vpc"

  tags = merge(
    { "Name" = "${var.vpc_name}-eip" },
    var.tags
  )
}

resource "aws_nat_gateway" "single_nat_gateway" {
  count         = local.nat_count
  allocation_id = aws_eip.single_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    { "Name" = "${var.vpc_name}-nat-gw" },
    var.tags
  )
}

############################################################################
###                  Route Table for Private Subnet                      ###
############################################################################

resource "aws_route_table" "private_route_table" {
  count  = local.create_private ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = "${var.vpc_name}-private-RT" },
    var.tags
  )
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = local.create_private ? length(var.private_subnet_cidr) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_route_table[0].id
}

# Add add a NAT gateway with private subnet route if enabled
resource "aws_route" "private_route_table_route" {
  count                  = local.nat_count
  route_table_id         = aws_route_table.private_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.single_nat_gateway[count.index].id
}

############################################################################
###                  Route Table for DB Subnet                           ###
############################################################################

resource "aws_route_table" "db_route_table" {
  count  = local.create_db ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = "${var.vpc_name}-database-RT" },
    var.tags
  )
}

resource "aws_route_table_association" "db_route_table_association" {
  count          = local.create_db ? length(var.db_subnet_cidr) : 0
  subnet_id      = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.db_route_table[0].id
}

############################################################################
###                  Route Table for Intra Subnet                        ###
############################################################################

resource "aws_route_table" "intra_route_table" {
  count  = local.create_intra ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = "${var.vpc_name}-intra-RT" },
    var.tags
  )
}

resource "aws_route_table_association" "intra_route_table_association" {
  count          = local.create_intra ? length(var.intra_subnet_cidr) : 0
  subnet_id      = aws_subnet.intra_subnet[count.index].id
  route_table_id = aws_route_table.intra_route_table[0].id
}
