variable "vpc_name" {
  description = "Name of the vpc"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "CIDR Block of the VPC"
  type        = string
  default     = "0.0.0.0/0"
}


# variable "instance_type" {
#   description = "Instance Type"
#   type        = string
#   default     = "t2.micro"
# }

# variable "key_name" {
#   description = "Key to access EC2 instance"
#   type        = string
#   default     = "access-key"
# }

# variable "public_sg_name" {
#   description = "Security Group Name for public facing SG"
#   type        = string
#   default     = "allow_public_access"
# }

# variable "public_sg_description" {
#   description = "Security Group Description for public facing SG"
#   type        = string
#   default     = "This rule will allow to access instance from Internet"
# }



variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}


variable "enable_single_nat_gateway" {
  description = "Should be true to create NAT gateway for private subnets"
  type        = bool
  default     = false
}


variable "enable_baston_host" {
  description = "Should be true to create Baston host on public subnet"
  type        = bool
  default     = false
}


variable "public_subnets" {
  description = "Mapping AZ and Public subnets"
  type        = map(any)
  default = {
    "ap-northeast-1a" = "10.0.0.0/20",
    "ap-northeast-1d" = "10.0.16.0/20"
  }
}


variable "private_subnets" {
  description = "Mapping AZ and Private subnets"
  type        = map(any)
  default = {
    "ap-northeast-1a" = "10.0.32.0/20",
    "ap-northeast-1d" = "10.0.48.0/20"
  }
}



