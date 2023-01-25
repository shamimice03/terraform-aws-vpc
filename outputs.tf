output "vpc_id" {
  description = "ID of the VPC"
  value       = try(aws_vpc.this_vpc.id, "")
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this_vpc.cidr_block, "")
}

/*
To use public subnet while deploying ec2 instance.
subnet_id = module.<module-name>.public_subnet_id["az-name"]
*/

output "public_subnet_id" {
  description = "Public Subnet ID's"
  value       = aws_subnet.public
}

output "private_subnet_id" {
  description = "Private Subnet ID's"
  value       = aws_subnet.private
}

output "igw_id" {
  description = "Internet Gateway ID's"
  value       = aws_internet_gateway.igw.id
}
