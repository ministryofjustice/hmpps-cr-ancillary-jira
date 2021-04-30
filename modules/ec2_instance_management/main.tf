resource "aws_instance" "instance" {
  ami                         = var.ec2_conf["ami_id"]
  instance_type               = var.ec2_conf["instance_type"]
  subnet_id                   = var.ec2_conf["subnet_id"]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = var.ec2_conf["associate_public_ip_address"]
  security_groups             = var.ec2_conf["security_groups"]
  monitoring                  = var.ec2_conf["monitoring"]
  user_data                   = data.template_file.ec2_user_data_template.rendered
  root_block_device {
    volume_size = var.ec2_conf["root_device_size"]
  }
  tags = merge(var.tags,
    map("Name", var.ec2_conf["app_name"])
  )
  lifecycle {
    ignore_changes = [
      ami,
      #user_data,
      security_groups
    ]
  }
}
