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
    target_group_arn = aws_lb_target_group.http.arn
    type             = "forward"
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
resource "aws_route53_record" "public_dns" {
  zone_id = data.terraform_remote_state.vpc.outputs.strategic_public_zone_id
  name    = local.app_name
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
  deregistration_delay = 90

  health_check {
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  depends_on = [aws_lb.alb]
}
