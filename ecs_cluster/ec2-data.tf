//# Search for ami id
//data "aws_ami" "ecs_ami" {
//  most_recent = true
//  owners      = ["amazon"]
//
//  # Amazon Linux 2 optimised ECS instance
//  filter {
//    name   = "name"
//    values = ["amzn2-ami-ecs-hvm-*"]
//  }
//
//  # correct arch
//  filter {
//    name   = "architecture"
//    values = ["x86_64"]
//  }
//
//  # Owned by Amazon
//  filter {
//    name   = "owner-alias"
//    values = ["amazon"]
//  }
//
//  filter {
//    name   = "virtualization-type"
//    values = ["hvm"]
//  }
//}
//
//# IAM Templates
//data "template_file" "ecs_assume_role_template" {
//  template = file("${path.module}/templates/iam/ecs-host-assumerole-policy.tpl")
//  vars     = {}
//}
//
//data "template_file" "ecs_host_role_policy_template" {
//  template = file("${path.module}/templates/iam/ecs-host-role-policy.tpl")
//  vars     = {}
//}
//
//# Host userdata template
//data "template_file" "ecs_host_userdata_template" {
//  template = file("${path.module}/templates/ec2/ecs-host-userdata.tpl")
//
//  vars = {
//    ecs_cluster_name         = aws_ecs_cluster.this.name
//    region                   = var.region
//    efs_sg                   = join(" ", local.jira_ecs_security_groups)
//    log_group_name           = "${var.environment_name}/shared-ecs-cluster"
//    cloudstor_plugin_version = var.cloudstor_plugin_version
//  }
//}
//
//# Hack to merge additional tag into existing map and convert to list for use with asg tags input
//data "null_data_source" "tags" {
//  count = length(keys(var.tags))
//
//  inputs = {
//    key                 = element(keys(var.tags), count.index)
//    value               = element(values(var.tags), count.index)
//    propagate_at_launch = true
//  }
//}
