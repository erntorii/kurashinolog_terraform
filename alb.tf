# ------------------------------------------------------------
# Application Load Balancer
# ------------------------------------------------------------
resource "aws_lb" "alb" {
  name               = "${var.prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_1a.id, aws_subnet.public_1c.id]
}

# ------------------------------------------------------------
# Target Group
# ------------------------------------------------------------
resource "aws_lb_target_group" "http" {
  name     = "${var.prefix}-http"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  depends_on = [aws_lb.alb]
}

# ------------------------------------------------------------
# HTTP Listener
# ------------------------------------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.http.arn
    type             = "forward"
  }
}

# ------------------------------------------------------------
# HTTPS Listener
# ------------------------------------------------------------
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.main.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = aws_lb_target_group.http.arn
    type             = "forward"
  }
}
