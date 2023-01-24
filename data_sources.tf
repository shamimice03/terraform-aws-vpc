data "aws_ami" "linx_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    values = [
      "amzn2-ami-kernel-*-hvm-*-x86_64-gp2"
    ]
  }

}