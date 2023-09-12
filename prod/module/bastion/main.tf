
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow OVPN and ssh, https"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = {
      1194 = "udp"
      22   = "tcp"
      943  = "tcp"
      443  = "tcp"
    }
    content {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = ingress.value
      description = ingress.value
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // tags = local.resource_tags
}

# resource "aws_instance" "ovpn_instance" {

#   depends_on = [aws_key_pair.keypair]

#   ami           = data.aws_ami.ovpn.image_id
#   subnet_id     = var.bastion_subnet[0].id
#   instance_type = "t2.micro"
#   key_name      = aws_key_pair.keypair.key_name

#   vpc_security_group_ids = [aws_security_group.bastion_sg.id]


#   associate_public_ip_address = true
#   root_block_device {
#     volume_size = 8
#   }
#   user_data = <<EOF
# admin_user=${var.ovpnuser}
# admin_pw=${var.ovpnpw}
# EOF
# //  tags = local.resource_tags
# }

resource "aws_instance" "ovpn_instance" {
  count      = var.count_num
  depends_on = [aws_key_pair.keypair]

  ami           = data.aws_ami.ovpn.image_id
  subnet_id     = var.bastion_subnet[count.index].id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.keypair.key_name

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]


  associate_public_ip_address = true
  root_block_device {
    volume_size = 8
  }
  user_data = <<EOF
admin_user=${var.ovpnuser}
admin_pw=${var.ovpnpw}
EOF


  //  tags = local.resource_tags
}

resource "aws_key_pair" "keypair" {
  key_name   = "${var.project_env}-key"
  public_key = var.keypair
  // tags       = local.resource_tags
}
///////////////////////
// lb /////
///////////////////////

resource "aws_security_group" "bastion_lb_sg" {
  name        = "bastion-lb-sg"
  description = "Allow all HTTP"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = {
      80  = "tcp"
      443 = "tcp"
      943 = "tcp"
    }
    content {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = ingress.value
      description = ingress.value
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_lb_target_group" "bastion_lb_tg" {
  name     = "bastion-lb-tg"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    path = "/?src=connect"
  }
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 180
  }
}

resource "aws_lb_target_group_attachment" "tg-attach" {
  count            = var.count_num
  target_group_arn = aws_lb_target_group.bastion_lb_tg.arn
  target_id        = aws_instance.ovpn_instance[count.index].id
  port             = 443
}


resource "aws_lb" "alb" {
  name = "bastion-alb"

  load_balancer_type = "application"
  security_groups    = [aws_security_group.bastion_lb_sg.id]
  subnets            = var.bastion_subnet[*].id

}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bastion_lb_tg.arn
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
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
