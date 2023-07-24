## Create AWS VPC using Terraform

### Usage
```hcl
module "vpc" {

    source = "shamimice03/vpc/aws"

    vpc_name = "prod-vpc"
    cidr     = "192.168.0.0/16"

    azs                 = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
    public_subnet_cidr  = ["192.168.0.0/20", "192.168.16.0/20", "192.168.32.0/20"]
    private_subnet_cidr = ["192.168.48.0/20", "192.168.64.0/20", "192.168.80.0/20"]
    db_subnet_cidr      = ["192.168.96.0/20", "192.168.112.0/20", "192.168.128.0/20"]
    intra_subnet_cidr   = ["192.168.144.0/20", "192.168.160.0/20", "192.168.176.0/20"]

    enable_dns_hostnames      = true
    enable_dns_support        = true
    enable_single_nat_gateway = false

    tags = {
      "Team" = "platform-team"
      "Env"  = "prod"
    }
}
```

### Outputs
| Name | Description | Type |
|------|---------|-----------|
vpc_id | VPC ID | `string`
vpc_cidr_block | The CIDR block of the VPC | `string`
public_subnet_id | Public Subnet ID's | `list`
private_subnet_id | Private Subnet ID's | `list`
db_subnet_id | DB Subnet ID's | `list`
intra_subnet_id | Intra Subnet ID's | `list`
igw_id | Internet Gateway ID's | `string`



***
### Others:
- [Subnet Calculator](https://www.solarwinds.com/free-tools/advanced-subnet-calculator)
