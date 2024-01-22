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

## Deploy VPN gateway

# resource "aviatrix_gateway" "aws_r1_vpn_0" {
#   cloud_type       = 1
#   account_name     = var.aws_account
#   gw_name          = "aws-${var.aws_r1_location_short}-vpn-0-${var.customer_name}"
#   vpc_id           = module.aws_r1_spoke_app1.vpc.vpc_id
#   vpc_reg          = var.aws_r1_location
#   gw_size          = "t3.small"
#   subnet           = module.aws_r1_spoke_app1.vpc.public_subnets[0].cidr
#   vpn_access       = true
#   vpn_cidr         = var.aws_r1_vpn_user_cidr
#   additional_cidrs = var.aws_r1_vpn_tunnel_cidr
#   max_vpn_conn     = "100"
#   split_tunnel     = true
#   enable_vpn_nat   = true
#   vpn_protocol     = "TCP"
# }

# ## User VPN
# resource "aviatrix_vpn_user" "aweiss" {

#   user_email = var.vpn_user_email
#   user_name  = var.vpn_user_name
#   gw_name    = aviatrix_gateway.aws_r1_vpn_0.gw_name
#   vpc_id     = module.aws_r1_spoke_app1.vpc.vpc_id

#   depends_on = [aviatrix_gateway.aws_r1_vpn_0]
# }
