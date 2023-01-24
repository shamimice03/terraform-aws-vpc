locals {
  vpc_id = aws_vpc.this_vpc.id

  public_azs_only  = keys(var.public_subnets)
  private_azs_only = keys(var.private_subnets)

  public_subnets_only  = values(var.public_subnets)
  private_subnets_only = values(var.private_subnets)

  nat_count = var.enable_single_nat_gateway == true ? 1 : 0

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


output "vpc_id" {
  description = "ID of the VPC"
  value = try(aws_vpc.this_vpc.id, "")
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this_vpc.cidr_block, "")
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


output "public_subnet_id" {
  value = aws_subnet.public
}

/*

To use public subnet while deploying ec2 instance.
subnet_id = module.<module-name>.public_subnet_id["az-name"]
*/


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

############################################################################
###       Internet Gateway
############################################################################
resource "aws_internet_gateway" "igw" {

  vpc_id = local.vpc_id

  tags = {
    "Name" = "${var.vpc_name}-igw"
  }

}

############################################################################
###       Route Table for Public Subnet
############################################################################
resource "aws_route_table" "public_route_table" {

  vpc_id = local.vpc_id

  tags = {
    "Name" = "${var.vpc_name}-public-rt"
  }
}

# Route Configuration for Public Subnets
resource "aws_route" "public_route_table_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Public Subnets with the Public Route Table
resource "aws_route_table_association" "public_route_table_association" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public_route_table.id
}

############################################################################
###       NAT GATEWAY
############################################################################


################# SINGLE NAT #################

# This configuration will deploy a single NAT gateway on the first public subnet 

resource "aws_eip" "single_eip" {
  count = local.nat_count
  vpc   = true
}

resource "aws_nat_gateway" "single_nat_gateway" {
  count         = local.nat_count
  allocation_id = aws_eip.single_eip[count.index].id
  subnet_id     = aws_subnet.public[local.public_azs_only[count.index]].id

  tags = {
    "Name" = "${var.vpc_name}-nat_gw"
  }
}

############################################################################
###       Route Table for Private Subnet
############################################################################

resource "aws_route_table" "private_route_table" {

  vpc_id = local.vpc_id

  tags = {
    "Name" = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private_route_table.id
}

# Add add a NAT gateway with private subnet route if enabled
resource "aws_route" "private_route_table_route" {
  count                  = local.nat_count
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.single_nat_gateway[count.index].id
}


# ############################## Public-Access-SG ##############################

# resource "aws_security_group" "public_access_sg" {

#   name        = var.public_sg_name
#   description = var.public_sg_description
#   vpc_id      = local.vpc_id

#   ingress {
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "allow public access"
#     from_port   = 0
#     protocol    = "-1"
#     to_port     = 0
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

# }


# ############################################################################
# ###                           Baston Host
# ############################################################################

# resource "aws_instance" "baston_host" {

#   count = var.enable_baston_host == true ? 1 : 0
#   ami           = data.aws_ami.linux_ami.id
#   instance_type = var.instance_type
#   subnet_id     = aws_subnet.public[local.public_azs_only[count.index]].id
#   key_name      = "access-key"
#   vpc_security_group_ids = [aws_security_group.public_access_sg.id]

#   tags = {
#     "Name" = "${var.vpc_name}-baston_host"
#   }
# }