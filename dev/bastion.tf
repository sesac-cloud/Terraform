
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow OVPN and ssh, https"
  vpc_id      = aws_vpc.vpc.id

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
  tags = local.resource_tags
}


resource "aws_instance" "instance_c" {
  depends_on = [aws_key_pair.keypair]

  ami           = data.aws_ami.ovpn.image_id
  subnet_id     = aws_subnet.bastion_subnet[0].id
  instance_type = "t2.micro"
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


  tags = local.resource_tags
}


resource "aws_key_pair" "keypair" {
  key_name   = "${var.project_env}-key"
  public_key = var.keypair
  tags       = local.resource_tags
}