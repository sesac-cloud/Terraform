resource "helm_release" "albc" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "clusterName"
    value = data.tfe_outputs.aws_output.values.cluster_name
  }

}


resource "helm_release" "edns" {
  depends_on = [helm_release.albc]
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  set {
    name  = "policy"
    value = "sync"
  }

}

resource "helm_release" "argocd" {
  depends_on       = [helm_release.edns]
  name             = "argocd"
  create_namespace = true
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  values = [
    templatefile("${path.module}/helm-values/argo-cd.yml", {
      domain       = var.ourdomain,
      tls_cert_arn = data.tfe_outputs.aws_output.values.cert_arn,
      subnetlist   = data.tfe_outputs.aws_output.values.bastion_subnet,
      vpccidr      = data.tfe_outputs.aws_output.values.vpccidr
      }
    )
  ]
  #   values = [ yamlencode(
  #     {

  #   "server": {
  #     "ingress": {
  #       "hosts": [
  #         "argocd.${var.our_domain}"
  #       ],
  #       "enabled": true,
  #       "path": null,
  #       "annotations": {
  #         "kubernetes.io/ingress.class": "alb",
  #         "alb.ingress.kubernetes.io/healthcheck-path": "/",
  #         "alb.ingress.kubernetes.io/target-type": "ip",
  #         "alb.ingress.kubernetes.io/scheme": "internet-facing",
  #         "alb.ingress.kubernetes.io/healthcheck-protocol": "HTTP",
  #         "alb.ingress.kubernetes.io/certificate-arn": "${var.tls_cert_arn}",
  #         "alb.ingress.kubernetes.io/ssl-redirect": "443",
  #         "alb.ingress.kubernetes.io/subnets": "${var.subnetlist}",
  #         "alb.ingress.kubernetes.io/backend-protocol": "HTTP",
  #         "alb.ingress.kubernetes.io/inbound-cidrs": "${var.vpccidr},112.172.128.1/32"
  #       }
  #     }
  #   }
  # }
  # )
  #   ]

}

resource "helm_release" "metric_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
}

resource "helm_release" "cluster-autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = ">= 9.29.0"

  values = [
    templatefile("${path.module}/helm-values/cluster-autoscaler.yml", {
      eks_asg_name = data.tfe_outputs.aws_output.values.eks_asg_name,
      region       = data.tfe_outputs.aws_output.values.current_region.id,
      role_arn     = data.tfe_outputs.aws_output.values.irsa_role
      }
    )
  ]
}

resource "helm_release" "datadog" {
  depends_on = [kubernetes_namespace.datadog]
  name       = "datadog-agent"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"
  namespace  = "datadog"

  values = [
    templatefile("${path.module}/helm-values/datadog-values.yaml", {
      apikey = var.datadog_api_key
      appkey = var.datadog_app_key
    })
  ]

}