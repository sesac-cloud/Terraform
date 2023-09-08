data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_ami" "ovpn" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*OpenVPN Access Server*"]
  }
}

data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_cluster.version}/amazon-linux-2/recommended/release_version"
}
//gpu 버전 ami
data "aws_ssm_parameter" "eks_gpu_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_cluster.version}/amazon-linux-2-gpu/recommended/release_version"
}



data "external" "thumbprint" {
  program = ["sh", "${path.module}/get_thumbprint.sh", data.aws_region.current.name]
}

data "aws_cloudfront_cache_policy" "cdn_cache_policy" {
  name = "Managed-CachingOptimized"
}
