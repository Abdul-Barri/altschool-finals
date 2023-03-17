data "kubectl_path_documents" "grafana-files" {
    pattern = "./*-grafana-*.yaml"
}

resource "kubectl_manifest" "grafana-deploy" {
    for_each  = toset(data.kubectl_path_documents.grafana-files.documents)
    yaml_body = each.value
}
