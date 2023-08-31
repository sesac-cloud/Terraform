# resource "aws_route53_zone" "primary" {
#   name = var.ourdomain
# }

resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.ourdomain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "ovpn_route" {
  zone_id = var.route53zoneid
  name    = "ovpn.jecheolso.site"
  type    = "A"
  ttl     = 300
  records = [aws_instance.instance_c.public_ip]
}