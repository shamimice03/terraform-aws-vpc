locals {
  vpc_id      = aws_vpc.this_vpc.id
  public_subnets_only  = values(var.public_subnets)
  private_subnets_only = values(var.private_subnets)
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
    In the above "locals", we have extracted the "suvnets" na using "values" function.
    
    Our target --
    Name = vpc_name-public_subnet-1
    Name = vpc_name-public_subnet-2

    For getting the index as a counter we are using "index" function 

    */

    "Name" = "${var.vpc_name}-public_subnet-${index(local.public_subnets_only, each.value) + 1}"
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
    "Name" = "${var.vpc_name}-private_subnet-${index(local.private_subnets_only, each.value) + 1}"
  }
}