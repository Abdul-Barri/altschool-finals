# Create kubernetes Name space

resource "kubernetes_namespace" "kube-namespace" {
  metadata {
    name = "portfolio-namespace"
    labels = {
      app = var.application-name
    }
  }
}

# Create kubernetes deployment for portfolio

resource "kubernetes_deployment" "kube-deployment" {
  metadata {
    name      = var.application-name
    namespace = kubernetes_namespace.kube-namespace.id
    labels = {
      app = var.application-name
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.application-name
      }
    }
    template {
      metadata {
        labels = {
          app = var.application-name
        }
      }
      spec {
        container {
          image = var.image
          name  = var.application-name
        }
      }
    }
  }
}

# Create kubernetes service

resource "kubernetes_service" "kube-service" {
  metadata {
    name      = var.application-name
    namespace = kubernetes_namespace.kube-namespace.id
  }
  spec {
    selector = {
      app = var.application-name
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

# Create kubernetes Name space for socks shop app

resource "kubernetes_namespace" "kube-namespace-socks" {
  metadata {
    name = "sock-shop"
  }
}

# Create kubectl deployment for socks app

data "kubectl_file_documents" "docs" {
    content = file("complete-demo.yaml")
}

resource "kubectl_manifest" "kube-deployment-socks-app" {
    for_each  = data.kubectl_file_documents.docs.manifests
    yaml_body = each.value
}

# Print out loadbalancer DNS hostname for portfolio deployment

output "portfolio_load_balancer_hostname" {
  value = kubernetes_service.kube-service.status.0.load_balancer.0.ingress.0.hostname
}

