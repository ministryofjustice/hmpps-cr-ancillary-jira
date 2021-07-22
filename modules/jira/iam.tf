## Module

# JIRA EC2 Host ROle
resource "aws_iam_role" "jira_role" {
  name               = "${var.jira_data["name"]}-pri-iam"
  assume_role_policy = data.template_file.ec2_assume_role_template.rendered
}

# JIRA EC2 Host Policy
resource "aws_iam_role_policy" "jira_role_policy" {
  name = "${var.jira_data["name"]}-pri-iam"
  role = aws_iam_role.jira_role.name

  policy = data.template_file.jira_role_policy_template.rendered
}

# JIRA EC2 Host Profile
resource "aws_iam_instance_profile" "jira_profile" {
  name = "${var.jira_data["name"]}-pri-iam"
  role = aws_iam_role.jira_role.name
}

resource "aws_iam_role_policy_attachment" "jira_ssm_agent" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.jira_role.name
}

resource "aws_iam_policy" "pri_s3_access_policy" {
  name   = "${var.jira_data["name"]}-pri-s3-iam"
  policy = data.template_file.ec2_s3_access_policy.rendered
}

resource "aws_iam_role_policy_attachment" "pri_s3_access_policy" {
  policy_arn = aws_iam_policy.pri_s3_access_policy.arn
  role       = aws_iam_role.jira_role.name
}
