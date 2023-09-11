
resource "aws_vpc" "vpc" {
  cidr_block = "172.18.0.0/16"

}

output "vpcid" {
  value = aws_vpc.vpc.id
}

module "s3" {
     source    = "./module/s3"
     cdn_distribution = module.cloudfront.cdn_distribution
     project_env = "prod"
  
}
module "cloudfront" {
     source    = "./module/cloudfront"
    s3domain    = module.s3.appbucket_domain_name

  
}