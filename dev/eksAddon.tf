
# resource "aws_eks_addon" "ebs-csi-drvier" {
#   cluster_name = aws_eks_cluster.eks_cluster.name
#   addon_name   = "aws-ebs-csi-driver"
# }


module "helm_addons" {
  source           = "./helm"
  cluster_ca_cert  = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  cluster_endpoint = aws_eks_cluster.eks_cluster.endpoint
  cluster_name     = aws_eks_cluster.eks_cluster.name
  our_domain       = var.ourdomain
  tls_cert_arn     = aws_acm_certificate.cert.arn
  subnetlist       = join(",", tolist(aws_subnet.bastion_subnet[*].id))
  vpccidr          = aws_vpc.vpc.cidr_block
}

