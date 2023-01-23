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