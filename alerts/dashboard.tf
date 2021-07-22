data "aws_lb_target_group" "target_group" {
  name = local.jira_ec2["aws_lb_target_group"]["name"]
}

data "aws_lb" "alb" {
  name = local.jira_ec2["aws_lb"]["name"]
}

data "template_file" "dashboard" {
  template = file("./files/dashboard.json")
  vars = {
    region                  = var.region
    asg_autoscale_name      = local.jira_ec2["aws_autoscaling_group"]["name"]
    common_prefix           = local.common_name
    lb_arn_suffix           = local.jira_ec2["aws_lb"]["arn_suffix"]
    target_group_arn_suffix = local.jira_ec2["aws_lb_target_group"]["arn_suffix"]
    # app_pool_httperr_offline = aws_cloudwatch_metric_alarm.iis_httperr.arn
  }
}

resource "aws_cloudwatch_dashboard" "jitbit" {
  dashboard_name = local.common_name
  dashboard_body = data.template_file.dashboard.rendered
}
