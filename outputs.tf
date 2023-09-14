output "vpc_id" {
  description = "ID of the VPC"
  value       = try(aws_vpc.this_vpc[0].id, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this_vpc[0].cidr_block, null)
}

output "public_subnet_id" {
  description = "Public Subnet ID's"
  value       = try(aws_subnet.public[*].id, null)
}

output "private_subnet_id" {
  description = "Private Subnet ID's"
  value       = try(aws_subnet.private[*].id, null)
}

output "db_subnet_id" {
  description = "DB Subnet ID's"
  value       = try(aws_subnet.db_subnet[*].id, null)
}

output "intra_subnet_id" {
  description = "DB Subnet ID's"
  value       = try(aws_subnet.intra_subnet[*].id, null)
}

output "igw_id" {
  description = "Internet Gateway ID's"
  value       = try(aws_internet_gateway.igw[0].id, null)
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
