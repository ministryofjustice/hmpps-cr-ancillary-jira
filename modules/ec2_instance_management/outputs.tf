output "this" {
  value = {
    aws_instance             = aws_instance.instance
    aws_iam_role             = aws_iam_role.ec2
    aws_iam_instance_profile = aws_iam_instance_profile.ec2_profile
  }
}
