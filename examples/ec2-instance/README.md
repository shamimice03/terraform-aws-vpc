# Deploy EC2-instances on your VPC

### VPC (Virtual Private Cloud)

- A VPC named "webapp_dev_vpc" with a CIDR block of "192.168.0.0/16" will be created in the AWS region specified in your provider configuration.
- This VPC will span three availability zones: "ap-northeast-1a," "ap-northeast-1c," and "ap-northeast-1d."
- Public and private subnets will be created in each of these availability zones, each with its own CIDR block.

### Security Groups

- A security group named "public_ssh_ping_access" will be created with ingress and egress rules allowing SSH, PING, HTTP, and HTTPS traffic from anywhere. This security group will be associated with the bastion host.
- Another security group named "ssh_ping_access_from_baston" will be created with ingress rules allowing SSH and PING traffic from the "public_ssh_ping_access" security group, which is effectively allowing SSH and PING access only from the bastion host.

### Baston Host

- An AWS EC2 instance named "Baston_Host" will be launched using a specified Amazon Machine Image (AMI) and instance type.
- It will be placed in the public subnet of the first availability zone (ap-northeast-1a).
- The instance will use the `aws_access` key pair for SSH access.
- Two files, `aws_access` and `get-docker.sh`, will be copied to the instance, and Docker will be installed on it.
- A connection will be established to the instance for file provisioning and execution of remote commands.
- Tags will be applied to the instance.

### Private Node

- An AWS EC2 instance named "Private_Node" will be launched using the same AMI and instance type.
- It will be placed in the private subnet of the first availability zone (ap-northeast-1c).
- The instance will use the "aws_access" key pair for SSH access.
- The "private_sg" security group will be associated with this instance.
- Tags will be applied to the instance.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.14.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_instance.baston_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.private_node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.private_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.public_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.linux_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance Type | `string` | `"t2.micro"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_node_ip"></a> [private\_node\_ip](#output\_private\_node\_ip) | pribate ip of EC2 instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
