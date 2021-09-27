# Load balancer
resource "aws_lb" "alb" {
  name               = "${var.environment_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = local.alb_security_groups
  subnets            = local.public_subnet_ids
  tags               = merge(var.tags, { "Name" = "${var.environment_name}-alb" })

  //  access_logs {
  //    enabled = true
  //    bucket  = data.terraform_remote_state.access_logs.outputs.bucket_name
  //    prefix  = local.app_name
  //  }

  lifecycle {
    create_before_destroy = true
  }
}

# Listeners
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.terraform_remote_state.vpc.outputs.strategic_public_ssl_arn[0]

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.http.arn
      }
      //      stickiness {
      //        enabled  = true
      //        duration = 36000
      //      }
    }

  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type = "redirect"
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# DNS
resource "aws_route53_record" "alb_public_dns" {
  name    = local.dns_name
  zone_id = local.public_zone_id
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.alb.dns_name]
}

resource "aws_route53_record" "alb_internal_dns" {
  name    = local.dns_name
  zone_id = local.internal_zone_id
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.alb.dns_name]
}

resource "aws_lb_target_group" "http" {
  name                 = "${var.environment_name}-http"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = local.vpc_id
  target_type          = "ip"
  deregistration_delay = 30

  stickiness {
    enabled = true
    type    = "lb_cookie"
  }

  health_check {
    timeout             = 120
    interval            = 300
    path                = "/status"
    protocol            = "HTTP"
    healthy_threshold   = 2
    matcher             = "200-499"
  }

  depends_on = [aws_lb.alb]
}
