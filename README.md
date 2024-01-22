# mpe-poc
All artifacts for PoC

# Context

For that PoC, we need :

- An Aviatrix Controller and Copilot deployed in a dedicated VPC.

- Aviatrix transit deployed in two AWS regions :
  - First transit in North Virinia being us-east-1, nammed use1 in the code,
  - Second transit in Sao Paulo being sa-east-1, named sae1 in the code,
  - Standard peering between those two regions over AWS backbone.

- Aviatrix spoke deployed in each of the above region :
  - Two VPCs, each with an Aviatrix spoke in first region,
  - Two VPCs, each with an Aviatrix spoke in second region,
  - Each spoke is peered with its regional transit.

- An Aviatrix VPN gateway is deployed along the spoke1 to be able to enter the dataplane
  - Default user is vpnuser

# Requirement

- At least one AWS account able to create AWS EC2 identity
- Subscribe to Aviatrix offer to get the customer ID (https://docs.aviatrix.com/documentation/latest/getting-started/getting-started-guide-aws.html)
- Subscribe to BYOL as per doc step to deploy controller and copilot stack
- A workstation that 
  - can access to terraform website,
  - can access github.com to clone repository,
  - can execute terraform code.
- A terraform.tfvars containing values like in terraform.tfvars.sample
  
# Assumptions

- For fast deploy, we assume PoC is deployed as NON highly available. This can be changed easily by updating terraform code
- We deploy Controller and Copilot is same region as first transit in a dedicated VPC
