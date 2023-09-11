
resource "aws_vpc" "vpc" {
  cidr_block = "172.18.0.0/16"

}

output "vpcid" {
  value = aws_vpc.vpc.id
}

module "s3" {
  source           = "./module/s3"
  cdn_arn = module.cloudfront.cdn_arn
  project_env      = "prod"

}
module "cloudfront" {
  source    = "./module/cloudfront"
  s3domain  = module.s3.appbucket_domain_name
  cdn_arn   = module.route53.us_1_cert_arn
  ourdomain = var.ourdomain
}
module "route53" {
  source     = "./module/route53"
  ourdomain  = var.ourdomain
  cdn_domain = module.cloudfront.cdn_domain
  route53zoneid = var.route53zoneid
}