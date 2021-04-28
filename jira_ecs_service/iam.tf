# Task Execution Role for pulling the image and put'ing logs to cloudwatch
resource "aws_iam_role" "jira_execute" {
  name               = "${local.name}-jira-exec-pri-iam"
  assume_role_policy = templatefile("${path.module}/templates/iam/ecs_assume_role_policy.tpl", {})
}

resource "aws_iam_role_policy" "jira_execute_policy" {
  name = "${local.name}-jira-exec-pri-iam"
  role = aws_iam_role.jira_execute.name
  policy = templatefile("${path.module}/templates/iam/exec_policy.tpl",
    {
      region         = var.region
      aws_account_id = data.aws_caller_identity.current.account_id
    }
  )
}

# Task role for the Jira task to interact with AWS services, e.g. managed ES
resource "aws_iam_role" "jira_task" {
  name               = "${local.name}-jira-task-pri-iam"
  assume_role_policy = templatefile("${path.module}/templates/iam/ecs_assume_role_policy.tpl", {})
}

//resource "aws_iam_role_policy" "jira_task_policy" {
//  name = "${local.name}-jira-task-pri-iam"
//  role = aws_iam_role.jira_task_role.name
//  policy = templatefile("${path.module}/templates/iam/jira_task_policy.tpl", {})
//}
