resource "aws_eks_addon" "example" {
  cluster_name = aws_eks_cluster.example.name
  addon_name   = "aws-ebs-csi-driver"
}