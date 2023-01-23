locals {
  vpc_id      = aws_vpc.this_vpc.id
  public_azs  = keys(var.public_subnets)
  private_azs = keys(var.private_subnets)
}

############################################################################
###        VPC 
############################################################################
resource "aws_vpc" "this_vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    "Name" = var.vpc_name
  }
}


############################################################################
###        Public Subnet 
############################################################################

resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  vpc_id                  = local.vpc_id
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = true

  tags = {

    /*
    How this is working..
    In the above "locals", we have extracted the "keys" of the "azs" using "keys" function.
    
    Our target --
    Name = vpc_name-public_subnet-1
    Name = vpc_name-public_subnet-2

    For getting the index we use "index" function 

    */

    "Name" = "${var.vpc_name}-public_subnet-${index(local.public_azs, each.key) + 1}"
  }
}


############################################################################
###        Private Subnet 
############################################################################

resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = local.vpc_id
  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    "Name" = "${var.vpc_name}-private_subnet-${index(local.private_azs, each.key) + 1}"
  }
}