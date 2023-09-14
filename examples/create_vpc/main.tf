module "vpc_1" {

  source = "../../"

  create = false

  vpc_name = "prod-vpc"
  cidr     = "192.168.0.0/16"

  azs                 = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnet_cidr  = ["192.168.0.0/20", "192.168.16.0/20", "192.168.32.0/20"]
  private_subnet_cidr = ["192.168.48.0/20", "192.168.64.0/20", "192.168.80.0/20"]
  db_subnet_cidr      = ["192.168.96.0/20", "192.168.112.0/20", "192.168.128.0/20"]
  intra_subnet_cidr   = ["192.168.144.0/20", "192.168.160.0/20", "192.168.176.0/20"]

  enable_dns_hostnames      = true
  enable_dns_support        = true
  enable_single_nat_gateway = true

  tags = {
    "Team" = "platform-team"
    "Env"  = "prod"
  }
}

module "vpc_2" {

  source = "../../"

  create = false

  vpc_name = "dev-vpc"
  cidr     = "192.169.0.0/16"

  azs                 = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  private_subnet_cidr = ["192.169.48.0/20", "192.169.64.0/20", "192.169.80.0/20"]
  intra_subnet_cidr   = ["192.169.96.0/20", "192.169.112.0/20", "192.169.128.0/20"]
  db_subnet_cidr      = ["192.169.144.0/20", "192.169.160.0/20", "192.169.176.0/20"]

  enable_dns_hostnames      = true
  enable_dns_support        = true
  enable_single_nat_gateway = false

  tags = {
    "Team" = "platform-team"
    "Env"  = "dev"
  }
}

module "vpc_3" {

  source = "../../"

  create = true

  vpc_name = "test-vpc"
  cidr     = "192.170.0.0/16"

  azs               = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  intra_subnet_cidr = ["192.170.96.0/20", "192.170.112.0/20", "192.170.128.0/20"]
  db_subnet_cidr    = ["192.170.144.0/20", "192.170.160.0/20", "192.170.176.0/20"]

  enable_dns_hostnames      = true
  enable_dns_support        = true
  enable_single_nat_gateway = false

  tags = {
    "Team" = "platform-team"
    "Env"  = "test"
  }
}

module "vpc_4" {

  source = "../../"

  create = true

  vpc_name = "check-vpc"
  cidr     = "192.171.0.0/16"

  tags = {
    "Team" = "platform-team"
    "Env"  = "check"
  }
}

module "vpc_5" {

  source = "../../"

  create = false
}
