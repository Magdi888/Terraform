# resource "aws_lb" "lb" {
#   name               = "app-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = [module.network.public_subnet-1_id, module.network.public_subnet-2_id]
# }


# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.lb.arn
#   port              = "80"
#   protocol          = "HTTP"
  

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_group.arn
#   }
# }

# resource "aws_lb_target_group" "target_group" {
#   name     = "lb-target-group"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = module.network.vpc_id
# }


# resource "aws_lb_target_group_attachment" "aws_lb_target_group_attachment" {
#   target_group_arn = aws_lb_target_group.target_group.arn
#   target_id        = aws_instance.bastion.id
#   port             = 80
# }
