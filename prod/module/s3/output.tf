output "appbucket_domain_name" {
  value = aws_s3_bucket.appbucket.bucket_regional_domain_name
}
output "logging_bucket" {
  value = aws_s3_bucket.loging.bucket
}