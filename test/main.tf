# variable "sg_config" {
#   type = list(any)
#   default = [
#     {
#       "from_port" : "80"
#       "to_port" : "8080"
#       "protocol" : "tcp"
#       "cidr_blocks" = "10.10.0.0/16"
#     },
#     {
#       "from_port" : "443"
#       "to_port" : "444"
#       "protocol" : "tcp"
#       "cidr_blocks" = "1.1.1.0/16"
#     },
#     {
#       "from_port" : "-1"
#       "to_port" : "-1"
#       "protocol" : "icmp"
#       "cidr_blocks" = "1.1.1.0/16"
#     },
#   ]

# }

# variable "sg_name" {
#   default = "test-sg-terraform"

# }

# variable "sg_description" {
#   default = "test-test-and-test"
# }

# resource "aws_security_group" "dynamicsg" {
#   name        = "dynamic-sg"
#   description = "Ingress for Vault"

#   dynamic "ingress" {
#     for_each = var.sg_config
#     iterator = port
#     content {
#       from_port   = port.value["from_port"]
#       to_port     = port.value["to_port"]
#       protocol    = port.value["protocol"]
#       //cidr_blocks = port.value["cidr_blocks"]
#     }
#   }
# }


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["1.1.1.1/32","2.2.0.0/22","10.3.97.0/24"]

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["1.1.1.1/32","0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}