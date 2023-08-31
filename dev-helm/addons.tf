resource "helm_release" "albc" {
  name       = "aws-load-balancer-controller"
  namespace = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "clusterName"
    value = "dev_eks_clusterhelm" 
}

}

resource "helm_release" "edns" {
  name       = "external-dns"
  namespace = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  set {
    name  = "policy"
    value = "sync"
}

}

resource "helm_release" "argocd" {
  name       = "argocd"
  create_namespace = true
  namespace = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"


}

resource "null_resource" "name" {
  depends_on = [ helm_release.argocd ]
  provisioner "local-exec" {
    command = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d >> ${path.module}/argocdpass.txt"
  }
  
}
