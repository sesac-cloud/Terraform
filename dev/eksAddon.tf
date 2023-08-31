
resource "aws_eks_addon" "ebs-csi-drvier" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "aws-ebs-csi-driver"
}

