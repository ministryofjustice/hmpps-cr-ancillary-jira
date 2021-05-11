## Module
resource "aws_route53_record" "alb_public_dns" {
  name    = var.jira_data["dns_name"]
  zone_id = var.jira_data["public_zone_id"]
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.jira_lb.dns_name]
}

resource "aws_route53_record" "alb_internal_dns" {
  name    = var.jira_data["dns_name"]
  zone_id = var.jira_data["internal_zone_id"]
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.jira_lb.dns_name]
}
