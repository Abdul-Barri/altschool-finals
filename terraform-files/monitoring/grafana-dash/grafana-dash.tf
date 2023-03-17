data "kubectl_path_documents" "grafana-dash-files" {
    pattern = "./*-grafana-*.yaml"
}

resource "kubectl_manifest" "grafana-dash-deploy" {
    for_each  = toset(data.kubectl_path_documents.grafana-dash-files.documents)
    yaml_body = each.value
}
