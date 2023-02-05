## Create AWS VPC using Terraform

## Usage
```
module "vpc" {

  source = "github.com/shamimice03/terraform_aws_vpc"

  vpc_name = "dev_vpc"
  cidr     = "192.168.0.0/16"

  public_subnets = {
    "ap-northeast-1a" = "192.168.0.0/20",
    "ap-northeast-1c" = "192.168.16.0/20",
    "ap-northeast-1d" = "192.168.32.0/20"
  }

  private_subnets = {
    "ap-northeast-1a" = "192.168.48.0/20",
    "ap-northeast-1c" = "192.168.64.0/20"
  }

  enable_dns_hostnames      = true
  enable_dns_support        = true
  enable_single_nat_gateway = false

  tags = {
    "Team" = "Platform-team"
    "Env"  = "dev"
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
