module "aws_r1_spoke_app1" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.6.7"

  cloud        = "AWS"
  name         = "aws-${var.aws_r1_location_short}-spoke-${var.application_1}-${var.customer_name}"
  cidr         = var.aws_r1_spoke_app1_cidr
  region       = var.aws_r1_location
  account      = var.aws_account
  transit_gw   = module.aws_transit_r1.transit_gateway.gw_name
  attached     = true
  ha_gw        = false
  single_az_ha = false
}

## Deploy Linux as Application 1 server
module "aws_r1_app1_vm" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = var.application_1

  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = "t3a.small"
  key_name                    = module.key_pair_r1.key_pair_name
  monitoring                  = true
  subnet_id                   = module.aws_r1_spoke_app1.vpc.private_subnets[0].subnet_id
  associate_public_ip_address = false

  tags = {
    Application = var.application_1
  }
}

module "aws_r1_spoke_app2" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.6.7"

  cloud        = "AWS"
  name         = "aws-${var.aws_r1_location_short}-spoke-${var.application_2}-${var.customer_name}"
  cidr         = var.aws_r1_spoke_app2_cidr
  region       = var.aws_r1_location
  account      = var.aws_account
  transit_gw   = module.aws_transit_r1.transit_gateway.gw_name
  attached     = true
  ha_gw        = false
  single_az_ha = false
}

## Deploy Linux as Application 2 server
module "aws_r1_app2_vm" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = var.application_2

  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = "t3a.small"
  key_name                    = module.key_pair_r1.key_pair_name
  monitoring                  = true
  subnet_id                   = module.aws_r1_spoke_app2.vpc.private_subnets[0].subnet_id
  associate_public_ip_address = false

  tags = {
    Application = var.application_2
  }
}
