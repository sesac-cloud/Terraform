

resource "aws_cloudfront_origin_access_control" "cdn_origin_access_control" {
  name = "${var.project_env}-cdnorigin"
  # description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Cloudfront Distribution
resource "aws_cloudfront_distribution" "cdn_distribution" {
  origin {
    domain_name              = var.s3domain
    origin_access_control_id = aws_cloudfront_origin_access_control.cdn_origin_access_control.id
    origin_id                = "converted_images"
    origin_path              = "/converted"
  }


  enabled         = true
  is_ipv6_enabled = true

  comment = "For Converted Images"


  # Alias of cloudfront distribution
  aliases = ["cdn.${var.ourdomain}"]

  # Default Cache behavior 
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "converted_images"
    compress         = true
    cache_policy_id  = data.aws_cloudfront_cache_policy.cdn_cache_policy.id



    viewer_protocol_policy = "redirect-to-https"

  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["KR"]
    }
  }

  # Certification Settings 
  viewer_certificate {
    #cloudfront_default_certificate = true
    acm_certificate_arn      = var.cdn_arn
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
  }

  # Cloudfront Logging Settings

  #   logging_config {
  #     include_cookies = false
  #     bucket          = ""
  #     prefix          = ""
  #   }




  #   tags = 

}




