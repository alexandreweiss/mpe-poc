output "ssh_aws_r1_app1" {
  value = module.aws_r1_app1_vm.private_ip
}

output "ssh_aws_r1_app2" {
  value = module.aws_r1_app2_vm.private_ip
}

output "ssh_aws_r2_app1" {
  value = module.aws_r2_app1_vm.private_ip
}

output "ssh_aws_r2_app2" {
  value = module.aws_r2_app2_vm.private_ip
}

output "ssh_aws_r1_app1_spoke_a" {
  value = var.aws_r1_spoke_a_app1_advertised_ip
}

output "ssh_aws_r1_app1_spoke_b" {
  value = var.aws_r1_spoke_b_app1_advertised_ip
}

output "aws_r1" {
  value = var.aws_r1_location
}

output "aws_r2" {
  value = var.aws_r2_location
}

output "guacamole_fqdn" {
  value = nonsensitive("https://${aws_eip.guacamole.public_dns}/#/index.html?username=guacadmin&password=${var.admin_password}")
}

# output "private_key" {
#   description = "Private key value"
#   value       = nonsensitive(module.key_pair_r1.private_key_pem)
# }
