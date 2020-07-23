resource "aws_lb" "kubernetes-nlb" {
  name               = "k8s-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public-subnet.id]

  enable_deletion_protection = true

  tags = {
    Terraform = "true"
    Name = "kubernetes"
  }
}

resource "aws_lb_target_group" "kubernetes-tg" {
  name     = "kubernetes-tg"
  port     = 6443
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.kubernetes-vpc.id
  # Network Load Balancers do not support Stickiness
  stickiness {
    type = "lb_cookie"
    enabled = false
  }

  tags = {
    Terraform = "true"
    Name = "kubernetes"
  }
}

# attach 3 master nodes as targets
resource "aws_lb_target_group_attachment" "tg-attachment" {
  count = 3
  target_group_arn = aws_lb_target_group.kubernetes-tg.arn
  target_id        = "10.0.1.1${count.index}"
  port             = 6443
}

resource "aws_lb_listener" "nlb-listener" {
  load_balancer_arn = aws_lb.kubernetes-nlb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kubernetes-tg.arn
  }
}