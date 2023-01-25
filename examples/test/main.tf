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


# module "aws_sg" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "baston-host-access-sg"
#   description = "Security group for baston-host"
#   vpc_id      = module.vpc.vpc_id

#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       description = "ssh"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       from_port   = -1
#       to_port     = -1
#       protocol    = "icmp"
#       description = "ping"
#       cidr_blocks = "0.0.0.0/0"
#     },
#   ]
#   egress_with_cidr_blocks = [
#     {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       description = "ssh"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       from_port   = -1
#       to_port     = -1
#       protocol    = "icmp"
#       description = "ping"
#       cidr_blocks = "0.0.0.0/0"
#     },

#   ]

# }

#  security group - access from Baston_host
resource "aws_security_group" "private_sg" {
  name        = "ssh_ping_access_from_baston"
  description = "Allow SSH and PING traffic to and from Baston-host"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {

    for_each = local.sg_ports_private_nodes
    content {
      from_port       = ingress.value["port"]
      to_port         = ingress.value["port"]
      protocol        = ingress.value["protocol"]
      security_groups = [aws_security_group.public_sg.id] # from this (baston_host) security group
    }
  }

  dynamic "egress" {

    for_each = local.sg_ports_private_nodes
    content {
      from_port       = egress.value["port"]
      to_port         = egress.value["port"]
      protocol        = egress.value["protocol"]
      security_groups = [aws_security_group.public_sg.id] # from this (baston_host) security group
    }
  }

  tags = {
    "Name" = "ssh_ping_access_from_baston"
  }
}
