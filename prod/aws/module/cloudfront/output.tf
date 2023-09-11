output "cdn_arn" {
  value = aws_cloudfront_distribution.cdn_distribution.arn
}
output "cdn_domain" {
  value = aws_cloudfront_distribution.cdn_distribution.domain_name
}