data "aws_ami" "ovpn" {
  most_recent = true


  filter {
    name   = "name"
    values = ["*OpenVPN Access Server*"]
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow all OVPN an ssh"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = {
      ovpn = 1194
      ssh  = 22
    }
    content {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
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

  ami           = data.aws_ami.ovpn.image_id
  subnet_id     = aws_subnet.bastion_subnet[0].id
  instance_type = "t2.micro"
  key_name      = "rhcsa"

  vpc_security_group_ids = [
    "${aws_security_group.bastion_sg.id}",
  ]


  associate_public_ip_address = true
  root_block_device {
    volume_size = 8
  }
  tags = local.resource_tags
}

