resource "aws_lb" "app_lb" {
  name               = "slack-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_sg.id]
#   subnets            = [aws_subnet.public.id]
    subnets            = [
        aws_subnet.public_subnet_1.id,
        aws_subnet.public_subnet_2.id
    ]
    enable_deletion_protection = false
}

resource "aws_lb_target_group" "app_tg" {
  name        = "slack-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

output "aws_lb" {
  value = aws_lb.app_lb.name
}