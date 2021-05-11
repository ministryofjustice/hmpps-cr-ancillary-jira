//output "this" {
//  value = {
//    thing1 = {
//      name = aws_resource.tf_resource_name.name
//      id   = aws_resource.tf_resource_name.id
//      arn  = aws_resource.tf_resource_name.arn
//    },
//    thing2 = {
//      name = aws_resource.tf_resource_name.name
//      id   = aws_resource.tf_resource_name.id
//      arn  = aws_resource.tf_resource_name.arn
//    }
//  }
//}



output "jira_ec2" {
  value = module.jira_ec2
}
