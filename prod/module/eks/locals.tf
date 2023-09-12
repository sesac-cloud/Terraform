locals {
  eks_cluster_policy    = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
  eks_node_group_policy = ["arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess","arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy", "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
}