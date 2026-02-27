
# Target Group 1 (for server1)
resource "aws_lb_target_group" "tg1" {
  name     = "alb-tg-1"           # Changed name slightly to avoid conflicts/duplicates
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = module.vpc.vpc_id  # Assuming this outputs the correct VPC ID

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = "200"          # Usually a string, though 200 works too
    path                = "/"
    port                = "traffic-port" # This is fine; it uses the target's registered port (80 here)
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3
  }
}

# Target Group 2 (for server2) — this was missing!
resource "aws_lb_target_group" "tg2" {
  name     = "alb-tg-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3
  }
}

# Attachment for server1 → tg1
resource "aws_lb_target_group_attachment" "tg1" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = aws_instance.server1.id
  port             = 80
}

# Attachment for server2 → tg2
resource "aws_lb_target_group_attachment" "tg2" {
  target_group_arn = aws_lb_target_group.tg2.arn
  target_id        = aws_instance.server2.id
  port             = 80
}

resource "aws_lb" "alb1" {
  name               = "alb-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg2.id]
  subnets            = module.vpc.public_subnets
  enable_deletion_protection = false
}

# Create Listener

resource "aws_lb_listener" "list1" {
  load_balancer_arn = aws_lb.alb1.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }
}
  
