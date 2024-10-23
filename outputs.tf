output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this_vpc[0].id, null)
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.this_vpc[0].arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this_vpc[0].cidr_block, null)
}

# Public Subnets
output "public_subnet_id" {
  description = "List of IDs of public subnets"
  value       = try(aws_subnet.public[*].id, [])
}

output "public_subnet_arn" {
  description = "List of ARNs of public subnets"
  value       = try(aws_subnet.public[*].arn, [])
}

output "public_subnet_cidr" {
  description = "List of CIDR blocks of public subnets"
  value       = try(aws_subnet.public[*].cidr_block, [])
}

# Private Subnets
output "private_subnet_id" {
  description = "List of IDs of private subnets"
  value       = try(aws_subnet.private[*].id, [])
}

output "private_subnet_arn" {
  description = "List of ARNs of private subnets"
  value       = try(aws_subnet.private[*].arn, [])
}

output "private_subnet_cidr" {
  description = "List of CIDR blocks of private subnets"
  value       = try(aws_subnet.private[*].cidr_block, [])
}

# Database Subnets
output "database_subnet_id" {
  description = "List of IDs of database subnets"
  value       = try(aws_subnet.db_subnet[*].id, [])
}

output "database_subnet_arn" {
  description = "List of ARNs of database subnets"
  value       = try(aws_subnet.db_subnet[*].arn, [])
}

output "database_subnet_cidr" {
  description = "List of CIDR blocks of database subnets"
  value       = try(aws_subnet.db_subnet[*].cidr_block, [])
}

# Intra Subnets
output "intra_subnet_id" {
  description = "List of IDs of intra subnets"
  value       = try(aws_subnet.intra_subnet[*].id, [])
}

output "intra_subnet_arn" {
  description = "List of ARNs of intra subnets"
  value       = try(aws_subnet.intra_subnet[*].arn, [])
}

output "intra_subnet_cidr" {
  description = "List of CIDR blocks of intra subnets"
  value       = try(aws_subnet.intra_subnet[*].cidr_block, [])
}

# Internet Gateway
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = try(aws_internet_gateway.igw[0].id, null)
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = try(aws_internet_gateway.igw[0].arn, null)
}

# NAT Gateway
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = try(aws_nat_gateway.single_nat_gateway[0].id, null)
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = try(aws_nat_gateway.single_nat_gateway[0].public_ip, null)
}

# Route Tables
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = try(aws_route_table.public_route_table[0].id, null)
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = try(aws_route_table.private_route_table[0].id, null)
}

output "database_route_table_id" {
  description = "ID of the database route table"
  value       = try(aws_route_table.db_route_table[0].id, null)
}

output "intra_route_table_id" {
  description = "ID of the intra route table"
  value       = try(aws_route_table.intra_route_table[0].id, null)
}

# output "public_subnets" {
#   description = "List of All Public Subnets"
#   value = [
#     for k, v in var.public_subnets : aws_subnet.public[k].id
#   ]
# }

# output "private_subnets" {
#   description = "List of All Private Subnets"
#   value = [
#     for k, v in var.private_subnets : aws_subnet.private[k].id
#   ]
# }
