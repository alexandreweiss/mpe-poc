data "aws_caller_identity" "aws_account" {}

resource "aws_cloudformation_stack" "avx_ctrl_cplt" {
  name         = "avxlabs-simple-deployment"
  template_url = var.template_url
  capabilities = ["CAPABILITY_IAM"]
  parameters = {
    AdminEmail                  = var.account_email
    AdminPassword               = var.admin_password
    AdminPasswordConfirm        = var.admin_password
    AllowedHttpsIngressIpParam  = var.allowed_source_ip_https
    ControllerInstanceTypeParam = var.instance_type
    CoPilotInstanceTypeParam    = var.instance_type
    HTTPProxy                   = "-"
    HTTPSProxy                  = "-"
    CustomerId                  = var.ctrl_customer_id
    DataVolSize                 = 100
    SubnetAZ                    = "${var.aws_r1_location}a"
    SubnetCidr                  = var.subnet_cidr
    TargetVersion               = var.ctrl_version
    VpcCidr                     = var.vpc_cidr
  }
  lifecycle {
    ignore_changes = [parameters["AdminPassword"], parameters["AdminPasswordConfirm"]]
  }
}

resource "time_sleep" "wait" {
  create_duration = "18m"
  depends_on      = [aws_cloudformation_stack.avx_ctrl_cplt]
}

data "http" "ctrl_auth" {
  provider             = http-full
  url                  = "https://${aws_cloudformation_stack.avx_ctrl_cplt.outputs.AviatrixControllerEIP}/v2/api"
  method               = "POST"
  insecure_skip_verify = true
  request_headers = {
    content-type = "application/json"
  }
  request_body = jsonencode({
    username = "admin",
    password = var.admin_password,
    action   = "login"
  })
  depends_on = [
    time_sleep.wait
  ]
}

data "http" "ctrl_label" {
  provider             = http-full
  url                  = "https://${aws_cloudformation_stack.avx_ctrl_cplt.outputs.AviatrixControllerEIP}/v1/api"
  method               = "POST"
  insecure_skip_verify = true
  request_headers = {
    content-type = "application/x-www-form-urlencoded"
  }
  request_body = "action=set_controller_name&controller_name=${var.ctrl_label_text}&CID=${jsondecode(data.http.ctrl_auth.response_body).CID}"
}
