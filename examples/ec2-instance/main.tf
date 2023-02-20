module "vpc" {
  source = "../../"

  vpc_name = "webapp_dev_vpc"
  cidr     = "192.168.0.0/16"

  azs                       = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnet_cidr        = ["192.168.0.0/20", "192.168.16.0/20", "192.168.32.0/20"]
  private_subnet_cidr       = ["192.168.48.0/20", "192.168.64.0/20", "192.168.80.0/20"]

  enable_dns_hostnames      = true
  enable_dns_support        = true
  enable_single_nat_gateway = true

  tags = {
    "Team" = "Platform-team"
    "Env"  = "dev"
  }
}

locals {
  sg_ports_baston_host = [
    {
      "port" : 443,
      "protocol" : "tcp"
    },
    {
      "port" : 80,
      "protocol" : "tcp"
    },
    {
      "port" : 22,
      "protocol" : "tcp"
    },
    {
      "port" : -1,
      "protocol" : "icmp"
    }
  ]

  sg_ports_private_nodes = [
    {
      "port" : 22,
      "protocol" : "tcp"
    },
    {
      "port" : -1,
      "protocol" : "icmp"
    }
  ]
}


resource "aws_security_group" "public_sg" {
  name        = "public_ssh_ping_access"
  description = "Allow SSH and PINGING from Anywhere"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {

    for_each = local.sg_ports_baston_host
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {

    for_each = local.sg_ports_baston_host
    content {
      from_port   = egress.value["port"]
      to_port     = egress.value["port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    "Name" = "public_ssh_ping_access"
  }
}

#  security group - access from Baston_host
resource "aws_security_group" "private_sg" {
  name        = "ssh_ping_access_from_baston"
  description = "Allow SSH and PING traffic to and from Baston-Host"
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "ssh_ping_access_from_baston"
  }
}

# Baston_Host
resource "aws_instance" "baston_host" {

  ami                    = data.aws_ami.linux_ami.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnet_id[0]  # ap-northeast-1a
  key_name               = "aws_access"
  vpc_security_group_ids = [aws_security_group.public_sg.id]


  provisioner "file" {
    source      = "~/.ssh/aws_access"      # Passing Private-Access key, so that baston_host can ssh to any private_node
    destination = "/tmp/aws_access"
  }

  provisioner "file" {
    source      = "get-docker.sh"
    destination = "/tmp/get-docker.sh"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("~/.ssh/aws_access")  # Location of Private-Access key
    timeout     = "4m"
  }


  provisioner "remote-exec" {
    inline = [
      "cp /tmp/aws_access ~/.ssh/",
      "chmod 400 ~/.ssh/aws_access",
      "scp -i ~/.ssh/aws_access -o 'StrictHostKeyChecking=no' /tmp/get-docker.sh ec2-user@${aws_instance.private_node.private_ip}:/tmp/",
      "ssh -i ~/.ssh/aws_access ec2-user@${aws_instance.private_node.private_ip} -o 'StrictHostKeyChecking=no' bash /tmp/get-docker.sh"
    ]
  }

  tags = {
    "Name" = "Baston_Host"
  }
}



# Private_Node
resource "aws_instance" "private_node" {

  ami                    = data.aws_ami.linux_ami.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnet_id[0]  # ap-northeast-1c
  key_name               = "aws_access"
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    "Name" = "Private_Node"
  }
}

output "private_node_ip" {
  value = aws_instance.private_node.private_ip
}




