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



# module "us_acm" {
#   source    = "../usacm"
#   ourdomain = var.ourdomain
# }

# resource "aws_route53_record" "cdn_a" {
#   zone_id = var.route53zoneid
#   name    = "cdn.${var.ourdomain}"
#   type    = "A"

#   alias {
#     name                   = var.cdn_domain
#     zone_id                = "Z2FDTNDATAQYW2"
#     evaluate_target_health = false
#   }
# }


resource "aws_route53_record" "ovpn_route" {
  zone_id = var.route53zoneid
  name    = "ovpn.${var.ourdomain}"
  type    = "A"

  alias {
    name = var.bastion_lb_dns
    zone_id = var.lb_zone_id
    evaluate_target_health = false
    
  }
}