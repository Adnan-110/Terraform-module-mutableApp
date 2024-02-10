# Creates Target Group 
resource "aws_lb_target_group" "app" {
  name          = "${var.COMPONENT}-${var.ENV}-tg"
  port          = var.APP_PORT
  protocol      = "HTTP"
  vpc_id        = data.terraform_remote_state.vpc.outputs.VPC_ID 

  health_check {
    path                = "/health"
    enabled             = true 
    interval            = 5
    timeout             = 4
    healthy_threshold   = 2
    unhealthy_threshold = 2
  } 
}

# Attaches the instances to the target group
resource "aws_lb_target_group_attachment" "attach_instances" {
  count             = local.TOTAL_INSTANCE_COUNT
  target_group_arn  = aws_lb_target_group.app.arn
  target_id         = element(local.INSTANCE_IDS, count.index)
  port              = var.APP_PORT 
}

#  Generates A Random Number
resource "random_integer" "priority" {
  min = 100
  max = 500
}

# Private Listener Rule
resource "aws_lb_listener_rule" "private_app_rule" {
  count         = var.INTERNAL ? 1 : 0
  listener_arn  = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
  priority      = random_integer.priority.result

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_NAME}"]
    }
  }
}

# Public Listener Rule
# resource "aws_lb_listener_rule" "public_app_rule" {
#   count         = var.INTERNAL ? 0 : 1
#   listener_arn  = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
#   priority      = random_integer.priority.result

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app.arn
#   }

#   condition {
#     path_pattern {
#       values = ["${var.COMPONENT}-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_NAME}"]
#     }
#   }
# }