variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key to access EC2 instance"
  type        = string
  default     = "access-key"
}

variable "public_sg_name" {
  description = "Security Group Name for public facing SG"
  type        = string
  default     = "allow_public_access"
}

variable "public_sg_description" {
  description = "Security Group Description for public facing SG"
  type        = string
  default     = "This rule will allow to access instance from Internet"
}

variable "enable_baston_host" {
  description = "Should be true to enable baston-host"
  type        = bool
  default     = false
}
