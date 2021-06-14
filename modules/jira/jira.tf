## Module

resource "aws_launch_configuration" "jira_host_lc" {
  name_prefix                 = "${var.jira_data["name"]}-lc"
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.jira_profile.name
  image_id                    = var.jira_conf["image_id"]
  instance_type               = var.jira_conf["instance_type"]

  security_groups = var.asg_security_groups

  user_data_base64 = base64encode(data.template_file.jira_user_data_template.rendered)
  key_name         = var.jira_data["ssh_deployer_key"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "jira_asg" {
  name                 = "${var.jira_data["name"]}-asg"
  launch_configuration = aws_launch_configuration.jira_host_lc.id
  target_group_arns    = [aws_lb_target_group.jira_lb_target_group.arn]

  # JIRA Server used - single instance only
  max_size = "1"
  min_size = "1"


  vpc_zone_identifier = var.private_subnet_ids

  tags = [
    for key, value in merge(var.tags, {
      "Name" = "${var.jira_data["name"]}-pri-asg"
      }) : {
      key                 = key
      value               = value
      propagate_at_launch = true
    }
  ]
}
