## Module

# EC2 Host Role
resource "aws_iam_role" "ec2" {
  name               = "${var.ec2_conf["app_name"]}-ec2-iam"
  assume_role_policy = data.template_file.ec2_assume_role_template.rendered
}

# EC2 Host Policy
resource "aws_iam_role_policy" "ec2_role_policy" {
  name = "${var.ec2_conf["app_name"]}-ec2-iam"
  role = aws_iam_role.ec2.name

  policy = data.template_file.ec2_role_policy.rendered
}

# EC2 Host Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.ec2_conf["app_name"]}-ec2-iam"
  role = aws_iam_role.ec2.name
}

resource "aws_iam_role_policy_attachment" "jira_ssm_agent" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2.name
}

resource "aws_iam_policy" "ec2_s3_access_policy" {
  name   = "${var.ec2_conf["app_name"]}-ec2-s3-iam"
  policy = data.template_file.ec2_s3_access_policy.rendered
}

resource "aws_iam_role_policy_attachment" "ec2_s3_access_policy" {
  policy_arn = aws_iam_policy.ec2_s3_access_policy.arn
  role       = aws_iam_role.ec2.name
}
