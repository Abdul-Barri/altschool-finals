resource "kubernetes_namespace" "kube-namespace-prometheus" {
  metadata {
    name = "monitoring"
  }
}

data "kubectl_path_documents" "prometheus-files" {
    pattern = "./*-prometheus-*.yaml"
}

resource "kubectl_manifest" "prometheus-deploy" {
    for_each  = toset(data.kubectl_path_documents.prometheus-files.documents)
    yaml_body = each.value
}
