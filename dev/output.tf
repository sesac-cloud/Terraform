output "acm_arn" {
  value = aws_acm_certificate.cert.arn
}

output "mq_url" {
  value = aws_mq_broker.mq_borker.instances.0.endpoints
}

output "db_url" {
  value = aws_db_instance.rds_instance.endpoint
}

# output "waf_acl" {
#   value = aws_wafv2_web_acl.waf_acl.arn
# }
output "pubsubnets" {
  value = aws_subnet.bastion_subnet[*].id
}

output "s3endpoint" {
  value = aws_vpc_endpoint.s3.id
}