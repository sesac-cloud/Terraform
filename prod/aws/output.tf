//////////////////////////////////////////////////
/////////////     For EKS       //////////////////
//////////////////////////////////////////////////
output "cluster_ca_cert" {
  value     = module.eks.cluster_ca_cert
  sensitive = true
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cert_arn" {
  value = module.route53.cert_arn
}

output "bastion_subnet" {
  value = join(",", tolist(module.vpc.bastion_subnet[*].id))

}
output "vpccidr" {
  value = module.vpc.vpc_cidr
}

//////////////////////////////////////////////////
/////////////     For EKS       //////////////////
//////////////////////////////////////////////////