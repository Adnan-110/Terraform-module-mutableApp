#Creates Listners for Public alb
resource "aws_lb_listener" "public" {
  count             = var.INTERNAL ? 0 : 1

  load_balancer_arn = data.terraform_remote_state.alb.outputs.PUBLIC_ALB_ARN
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.app.arn
  }
}

