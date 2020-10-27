variable "ssm_parameters" {
  type = list(string)
  default = [
    "/kurashinolog/DB_HOST",
    "/kurashinolog/DB_DATABASE",
    "/kurashinolog/DB_USERNAME",
    "/kurashinolog/DB_PASSWORD",
    "/kurashinolog/RAILS_MASTER_KEY",
    "/kurashinolog/AWS_ACCESS_KEY",
    "/kurashinolog/AWS_SECRET_KEY",
    "/kurashinolog/AWS_REGION",
    "/kurashinolog/AWS_BUCKET"
  ]
}

resource "aws_ssm_parameter" "main" {
  count = length(var.ssm_parameters)
  name  = var.ssm_parameters[count.index]
  value = "uninitialized"
  type  = "SecureString"

  lifecycle {
    ignore_changes = [value]
  }
}
