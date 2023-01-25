# terraform_aws_vpc
Create AWS VPC using terraform

Function used

values
keys
index
merge

```
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

tags = {
  "Team" = "Platform-team"
  "Env"  = "dev"
}
```