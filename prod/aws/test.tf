
resource "aws_vpc" "vpc" {
  cidr_block = "172.18.0.0/16"

}

output "vpcid" {
  value = aws_vpc.vpc.id
}

module "vpc" {
  source = "../module/vpc"
    count_num = 4

}

module "s3" {
  source           = "../module/s3"
  cdn_arn = module.cloudfront.cdn_arn
  s3_endpoint = module.vpc.s3_endpoint
  project_env      = var.project_env

}
module "cloudfront" {
  source    = "../module/cloudfront"
  s3domain  = module.s3.appbucket_domain_name
  cdn_arn   = module.route53.us_1_cert_arn
  ourdomain = var.ourdomain
  project_env = var.project_env

}
module "route53" {
  source     = "../module/route53"
  ourdomain  = var.ourdomain
  cdn_domain = module.cloudfront.cdn_domain
  route53zoneid = var.route53zoneid
}

resource "aws_ecr_repository" "ecr_repo" {
  for_each     = toset(local.containers)
  name         = "${var.project_env}-${each.key}"
 // tags         = local.resource_tags
  force_delete = true
}

module "mq" {
  source = "../module/mq"
  mq_subnet = module.vpc.mq_subnet
  vpc_id = module.vpc.vpc_id
  mqpw = var.mqpw
  mquser = var.mquser
  project_env = var.project_env
}

module "eks" {
  source = "../module/eks"
  project_env = var.project_env
  vpc_cidr = module.vpc.vpc_cidr
  vpc_id = module.vpc.vpc_id
  node_instance = var.node_instance
  k8s_subnet = module.vpc.k8s_subnet
}