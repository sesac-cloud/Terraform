#  resource "aws_route53_zone" "primary" {
#    name = "https://${var.domain}"
#  }

#  resource "aws_acm_certificate" "cert" {
#   domain_name       = "*.${var.domain}"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }