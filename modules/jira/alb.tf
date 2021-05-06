## Module

resource "aws_lb" "jira_lb" {
  name                       = "${var.jira_data["name"]}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.alb_security_groups
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = true
  tags = merge(
    var.tags,
    {
      "Name" = "${var.jira_data["name"]}-alb"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "jira_lb_target_group" {
  name     = "${var.jira_data["name"]}-alb-tg"
  vpc_id   = var.jira_data["vpc_id"]
  protocol = "HTTP"
  port     = "8080"
  tags = merge(
    var.tags,
    {
      "Name" = "${var.jira_data["name"]}-alb-tg"
    },
  )

  health_check {
    protocol = "HTTP"
    path     = "/status"
    matcher  = "200-399"
  }
}

resource "aws_lb_listener" "internal_lb_https_listener" {
  load_balancer_arn = aws_lb.jira_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.jira_data["public_ssl_arn"]

  default_action {
    target_group_arn = aws_lb_target_group.jira_lb_target_group.arn
    type             = "forward"
  }
}


## Comment out after upgrade
//  default_action {
//    type = "fixed-response"
//
//    fixed_response {
//      content_type = "text/plain"
//      message_body = "Jira upgrade in process"
//      status_code  = "503"
//    }
//  }
//}
//
//## Comment out after upgrade
//resource "aws_lb_listener_rule" "static" {
//  listener_arn = aws_lb_listener.internal_lb_https_listener.arn
//  priority     = 100
//
//  action {
//    target_group_arn = aws_lb_target_group.jira_lb_target_group.arn
//    type             = "forward"
//  }
//
//  condition {
//    source_ip {
//      values = ["82.39.185.97/32"]
//    }
//  }
//}

resource "aws_lb_listener" "internal_lb_http_redirect_listener" {
  load_balancer_arn = aws_lb.jira_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
