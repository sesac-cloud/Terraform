provider "helm" {
  kubernetes {
    host                   = data.tfe_outputs.aws_output.values.cluster_endpoint
    cluster_ca_certificate = base64decode(data.tfe_outputs.aws_output.values.cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.tfe_outputs.aws_output.values.cluster_name]
      command     = "aws"
    }
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}