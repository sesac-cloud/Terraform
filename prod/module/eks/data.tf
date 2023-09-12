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
