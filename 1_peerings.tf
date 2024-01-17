module "transit_peering" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.8"

  transit_gateways = [
    module.aws_transit_r1.transit_gateway.gw_name,
    module.aws_transit_r2.transit_gateway.gw_name
  ]
}
