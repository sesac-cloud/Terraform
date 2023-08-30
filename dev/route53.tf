resource "aws_route53_zone" "primary" {
  name = var.ourdomain
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.ourdomain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}