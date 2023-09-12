data "aws_ami" "ovpn" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*OpenVPN Access Server*"]
  }
}
