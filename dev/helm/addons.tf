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

resource "time_sleep" "wait_1_min_edns" {
  depends_on = [helm_release.albc]
  create_duration = "60s"
}
resource "time_sleep" "wait_1_min_argocd" {
  depends_on = [helm_release.edns]
  create_duration = "60s"
}

resource "helm_release" "edns" {
  depends_on = [ time_sleep.wait_1_min_edns ]
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
  depends_on = [ time_sleep.wait_1_min_argocd ]
  name       = "argocd"
  create_namespace = true
  namespace = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  values = [ yamlencode(
    {
      "configs": {
    "params": {
      "server.insecure": true
    }
  },
  "server": {
    "ingress": {
      "hosts": [
        "argocd.${var.our_domain}"
      ],
      "enabled": true,
      "path": null,
      "annotations": {
        "kubernetes.io/ingress.class": "alb",
        "alb.ingress.kubernetes.io/healthcheck-path": "/",
        "alb.ingress.kubernetes.io/target-type": "ip",
        "alb.ingress.kubernetes.io/scheme": "internet-facing",
        "alb.ingress.kubernetes.io/healthcheck-protocol": "HTTP",
        "alb.ingress.kubernetes.io/certificate-arn": "${var.tls_cert_arn}",
        "alb.ingress.kubernetes.io/ssl-redirect": "443",
        "alb.ingress.kubernetes.io/subnets": "${var.subnetlist}",
        "alb.ingress.kubernetes.io/backend-protocol": "HTTP",
        "alb.ingress.kubernetes.io/inbound-cidrs": "${var.vpccidr},112.172.128.1/32"
      }
    }
  }
}
)
  ]
    
}

resource "helm_release" "metric_server" {
  name       = "metrics-server"
  namespace = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
}



