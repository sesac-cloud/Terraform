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
output "current_region" {
  value = data.aws_region.current
}
output "eks_asg_name" {
  value = module.eks.eks_asg_name
}
output "irsa_role" {
  value = module.eks.irsa_role  
}
//////////////////////////////////////////////////
/////////////     For EKS       //////////////////
//////////////////////////////////////////////////