# ECS Host Role
resource "aws_iam_role" "ecs_host_role" {
  name               = "${local.name}-ecshost-private-iam"
  assume_role_policy = data.template_file.ecs_assume_role_template.rendered
}

# ECS Host Policy
resource "aws_iam_role_policy" "ecs_host_role_policy" {
  name = "${local.name}-ecshost-private-iam"
  role = aws_iam_role.ecs_host_role.name

  policy = data.template_file.ecs_host_role_policy_template.rendered
}

# ECS Host Profile
resource "aws_iam_instance_profile" "ecs_host_profile" {
  name = "${local.name}-ecscluster-private-iam"
  role = aws_iam_role.ecs_host_role.name
}
