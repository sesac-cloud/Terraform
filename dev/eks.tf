resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_env}_eks_cluster_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role" "eks_node_group_role" {
  name = "${var.project_env}_eks_node_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_cluster.version}/amazon-linux-2/recommended/release_version"
}
//gpu 버전 ami
# data "aws_ssm_parameter" "eks_gpu_ami_release_version" {
#   name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_cluster.version}/amazon-linux-2-gpu/recommended/release_version"
# }

resource "aws_eks_node_group" "eks_node_group" {

  cluster_name = aws_eks_cluster.eks_cluster.name

  node_group_name = "${var.project_env}_normal_node_group"

  subnet_ids = aws_subnet.k8s_subnet[*].id

  instance_types = [var.eksinstance]

  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 2
  }

  node_role_arn = aws_iam_role.eks_node_group_role.arn

}


resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project_env}_eks_cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.27"

  vpc_config {
    subnet_ids              = aws_subnet.k8s_subnet[*].id
    security_group_ids      = [aws_security_group.eks_node_group_sg.id]
    endpoint_private_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

resource "aws_security_group" "eks_node_group_sg" {
  name        = "node-group-sg"
  description = "For Nodegroup"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.resource_tags
}
data "aws_region" "current" {
}

data "external" "thumbprint" {
  program = ["${path.module}/get_thumbprint.sh", data.aws_region.current.name]
}

resource "aws_iam_openid_connect_provider" "iamoidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result.thumbprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

