## Create AWS VPC using Terraform

## Usage
```
module "vpc" {

  source = "github.com/shamimice03/terraform-aws-vpc"

  vpc_name = "prod_vpc"
  cidr     = "192.168.0.0/16"

  public_subnets_azs  = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnets_cidr = ["192.168.0.0/20", "192.168.16.0/20", "192.168.32.0/20"]

  private_subnets_azs  = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  private_subnets_cidr = ["192.168.48.0/20", "192.168.64.0/20", "192.168.80.0/20"]

  enable_dns_hostnames      = true
  enable_dns_support        = true
  enable_single_nat_gateway = false

  tags = {
    "Team" = "Platform-team"
    "Env"  = "prod_env"
  }

}
```

## Function Used

| Function        | Link         
| ------------- |:-------------:| 
| index      | [Link](https://developer.hashicorp.com/terraform/language/functions/index_function)
| keys       | [Link](https://developer.hashicorp.com/terraform/language/functions/keys)   
| values     | [Link](https://developer.hashicorp.com/terraform/language/functions/values)
| merge      | [Link](https://developer.hashicorp.com/terraform/language/functions/merge)
