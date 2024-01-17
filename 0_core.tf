module "key_pair_r1" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "aviatrix_${var.aws_r1_location_short}-${var.customer_name}"
  create_private_key = true
}

module "key_pair_r2" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "aviatrix_${var.aws_r2_location_short}-${var.customer_name}"
  create_private_key = true
  providers = {
    aws = aws.r2
  }
}

## Linux image search
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_ami" "ubuntu_r2" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"]
  }
  provider = aws.r2
}
