output "cluster_ca_cert" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}
output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}
output "irsa_role" {
  value = module.cluster_autoscaler_irsa_role.iam_role_arn
}

output "eks_asg_name" {
  value = aws_eks_node_group.eks_node_group.resources[0].autoscaling_groups[0].name
}