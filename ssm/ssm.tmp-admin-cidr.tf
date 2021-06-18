## SSM Parameter for storing the temp admin user CIDRs.
## This is to avoid storing permanently engineer's home/office IPs
## Value should be added manually via the AWS console for the correct account / environment.

resource "aws_ssm_parameter" "tmp_admin_cidr" {
  name        = "/${var.environment_name}/tmp_admin_cidr"
  description = "Temporary admin user access cidrs"
  type        = "String"
  value       = "{}"
  tags        = merge(var.tags, { "Name" = "/${var.environment_name}/tmp_admin_cidr" })

  lifecycle {
    ignore_changes = [value]
  }
}
