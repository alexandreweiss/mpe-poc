output "controller_public_ip" {
  value = aws_cloudformation_stack.avx_ctrl_cplt.outputs.AviatrixControllerEIP
}

output "copilot_public_ip" {
  value = aws_cloudformation_stack.avx_ctrl_cplt.outputs.AviatrixCoPilotEIP
}

output "controller_admin_password" {
  value     = var.admin_password
  sensitive = true
}

output "controller_security_group_id" {
  value = aws_cloudformation_stack.avx_ctrl_cplt.outputs.AviatrixControllerSecurityGroupID
}

output "copilot_security_group_id" {
  value = aws_cloudformation_stack.avx_ctrl_cplt.outputs.AviatrixCoPilotSecurityGroupID
}
