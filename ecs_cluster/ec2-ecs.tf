# Host Launch Configuration
resource "aws_launch_configuration" "ecs_host_lc" {
  name                 = "${local.name}-ecscluster-private-asg"
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ecs_host_profile.name
  image_id                    = data.aws_ami.ecs_ami.id
  instance_type               = var.ecs_instance_type

  security_groups = local.jira_ecs_security_groups

  user_data_base64 = base64encode(data.template_file.ecs_host_userdata_template.rendered)
  key_name         = data.terraform_remote_state.vpc.outputs.ssh_deployer_key

  lifecycle {
    create_before_destroy = true
  }
}

# Host ASG
resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "${local.name}-ecscluster-private-asg"
  launch_configuration = aws_launch_configuration.ecs_host_lc.id

  # Not setting desired count as that could cause scale in when deployment runs and lead to resource exhaustion
  max_size = var.node_max_count
  min_size = var.node_min_count

  vpc_zone_identifier = local.private_subnet_ids

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }

  tags = concat(data.null_data_source.tags.*.outputs, [{
    key                 = "Name"
    value               = "${local.name}-ecscluster-private-asg"
    propagate_at_launch = true
  }])
}

# Autoscaling Policies and trigger alarms
resource "aws_autoscaling_policy" "ecs_host_scaleup" {
  name                   = "${local.name}-ecssclup-pri-asg"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
}

resource "aws_autoscaling_policy" "ecs_host_scaledown" {
  name                   = "${local.name}-ecsscldown-pri-asg"
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
}

resource "aws_cloudwatch_metric_alarm" "ecs_scaleup_alarm" {
  alarm_name          = "${local.name}-ecssclup-cpu-cwa"
  alarm_description   = "ECS cluster scaling metric above threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.ecs_scale_up_cpu_threshold
  alarm_actions       = [aws_autoscaling_policy.ecs_host_scaleup.arn]

  dimensions = {
    ClusterName = aws_ecs_cluster.this.name
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_scaleup_mem_alarm" {
  alarm_name          = "${local.name}-ecssclup-mem-cwa"
  alarm_description   = "ECS cluster scaling metric above threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.ecs_scale_up_cpu_threshold
  alarm_actions       = [aws_autoscaling_policy.ecs_host_scaleup.arn]

  dimensions = {
    ClusterName = aws_ecs_cluster.this.name
  }
}

# Scaling down must only happen if both cpu and mem reservations are below the threshold
resource "aws_cloudwatch_metric_alarm" "ecs_scaledown_alarm" {
  alarm_name          = "${local.name}-ecsscldown-cpu-cwa"
  alarm_description   = "ECS cluster scaling metric under threshold"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "5"
  threshold           = "1"
  alarm_actions       = [aws_autoscaling_policy.ecs_host_scaledown.arn]

  metric_query {
    id          = "mq"
    expression  = "CEIL((cpu-${var.ecs_scale_down_cpu_threshold})/100)+CEIL((mem-${var.ecs_scale_down_mem_threshold})/100)"
    label       = "ECS Cluster CPU and Mem Reservations are BOTH Below Threshold for Scale Down"
    return_data = "true"
  }

  metric_query {
    id = "cpu"
    metric {
      metric_name = "CPUReservation"
      namespace   = "AWS/ECS"
      period      = "120"
      stat        = "Maximum"
      unit        = "Percent"
      dimensions = {
        ClusterName = aws_ecs_cluster.this.name
      }
    }
  }

  metric_query {
    id = "mem"
    metric {
      metric_name = "MemoryReservation"
      namespace   = "AWS/ECS"
      period      = "120"
      stat        = "Maximum"
      unit        = "Percent"
      dimensions = {
        ClusterName = aws_ecs_cluster.this.name
      }
    }
  }
}
