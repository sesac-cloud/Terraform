module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"

  cluster_name      = aws_eks_cluster.eks_cluster.name
  cluster_endpoint  = aws_eks_cluster.eks_cluster.endpoint
  cluster_version   = aws_eks_cluster.eks_cluster.version
  oidc_provider_arn = aws_eks_identity_provider_config.oidc_config.arn

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  enable_aws_load_balancer_controller    = true
  enable_karpenter                       = true
  enable_metrics_server                  = true
  enable_external_dns                    = true

}