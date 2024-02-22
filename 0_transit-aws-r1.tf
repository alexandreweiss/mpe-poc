module "aws_transit_r1" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.5.2"

  cloud                  = "aws"
  region                 = var.aws_r1_location
  cidr                   = var.aws_transit_r1_cidr
  account                = var.aws_account
  enable_transit_firenet = true
  gw_name                = "aws-${var.aws_r1_location_short}-transit-${var.customer_name}"
  name                   = "aws-${var.aws_r1_location_short}-transit-${var.customer_name}"
  ha_gw                  = false
}
