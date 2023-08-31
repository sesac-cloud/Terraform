locals {
  use_az = [
    "${var.use_region}a",
    "${var.use_region}c"
  ]
}

locals {
  resource_tags = {
    ProjectEnv = var.project_env
  }
  suffix_name = var.project_env
}

locals {
  containers = [
    "backend",
    "frontend",
    "api"
  ]
}

locals {
  eks_cluster_policy    = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
  eks_node_group_policy = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"]
}