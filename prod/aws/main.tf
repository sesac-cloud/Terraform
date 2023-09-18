
resource "aws_vpc" "vpc" {
  cidr_block = "172.18.0.0/16"

}

output "vpcid" {
  value = aws_vpc.vpc.id
}

module "vpc" {
  source    = "../module/vpc"
  count_num = 3

}

module "s3" {
  source      = "../module/s3"
  cdn_arn     = module.cloudfront.cdn_arn
  s3_endpoint = module.vpc.s3_endpoint
  project_env = var.project_env

}
module "cloudfront" {
  source      = "../module/cloudfront"
  s3domain    = module.s3.appbucket_domain_name
  cdn_arn     = module.route53.us_1_cert_arn
  ourdomain   = var.ourdomain
  project_env = var.project_env

}
module "route53" {
  source         = "../module/route53"
  ourdomain      = var.ourdomain
  cdn_domain     = module.cloudfront.cdn_domain
  route53zoneid  = var.route53zoneid
  bastion_lb_dns = module.bastion.bastion_lb_dns
  lb_zone_id     = module.bastion.lb_zone_id
}


module "bastion" {
  source         = "../module/bastion"
  count_num      = 3
  bastion_subnet = module.vpc.bastion_subnet
  ovpnuser       = var.ovpnuser
  ovpnpw         = var.ovpnpw
  keypair        = var.keypair
  vpc_id         = module.vpc.vpc_id
  cert_arn       = module.route53.cert_arn
  project_env    = var.project_env
}


resource "aws_ecr_repository" "ecr_repo" {
  for_each = toset(local.containers)
  name     = "${var.project_env}-${each.key}"
  // tags         = local.resource_tags
  force_delete = true
}
module "rds_cluster" {
  source      = "../module/rds"
  dbpw        = var.dbpw
  dbuser      = var.dbuser
  db_subnet   = module.vpc.db_subnet
  project_env = var.project_env
  vpc_id      = module.vpc.vpc_id

}

module "mq" {
  source      = "../module/mq"
  mq_subnet   = module.vpc.mq_subnet
  vpc_id      = module.vpc.vpc_id
  mqpw        = var.mqpw
  mquser      = var.mquser
  project_env = var.project_env
}

module "eks" {
  source        = "../module/eks"
  project_env   = var.project_env
  vpc_cidr      = module.vpc.vpc_cidr
  vpc_id        = module.vpc.vpc_id
  node_instance = var.node_instance
  k8s_subnet    = module.vpc.k8s_subnet
  broker_name = module.mq.broker_name
}

resource "aws_cognito_user_pool" "pool" {
  name = "snapdog-user-pool"
  alias_attributes = ["preferred_username","email"]
  admin_create_user_config  {
    allow_admin_create_user_only = false
  }
  email_configuration  {
    email_sending_account = "COGNITO_DEFAULT"
  }
}