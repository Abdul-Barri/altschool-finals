# PORTFOLIO DEPLOYMENT

# Create kubernetes Name space for portfolio

resource "kubernetes_namespace" "kube-namespace-portfolio" {
  metadata {
    name = "portfolio-namespace"
    labels = {
      app = "portfolio"
    }
  }
}

# Create kubernetes deployment for portfolio

resource "kubernetes_deployment" "kube-deployment-portfolio" {
  metadata {
    name      = "portfolio"
    namespace = kubernetes_namespace.kube-namespace-portfolio.id
    labels = {
      app = "portfolio"
    } 
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "portfolio"
      }
    }
    template {
      metadata {
        labels = {
          app = "portfolio"
        }
      }
      spec {
        container {
          image = "abdulbarri/portfolio:1.0"
          name  = "portfolio"
        }
      }
    }
  }
}

# Create kubernetes service for portfolio

resource "kubernetes_service" "kube-service-portfolio" {
  metadata {
    name      = "portfolio"
    namespace = kubernetes_namespace.kube-namespace-portfolio.id
  }
  spec {
    selector = {
      app = "portfolio"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

# SOCKS SHOP DEPLOYMENT

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

resource "kubectl_manifest" "kube-deployment-socks" {
    for_each  = data.kubectl_file_documents.docs.manifests
    yaml_body = each.value
}

# Create separate kubernetes service for socks shop frontend

resource "kubernetes_service" "kube-service-socks" {
  metadata {
    name      = "front-end"
    namespace = kubernetes_namespace.kube-namespace-socks.id
    annotations = {
      "prometheus.io/scrape" = "true"
    }
    labels = {
      name = "front-end"
    }
  }
  spec {
    selector = {
      name = "front-end"
    }
    port {
      port        = 80
      target_port = 8079
    }
    type = "LoadBalancer"
  }
}

# Print out loadbalancer DNS hostname for portfolio deployment

output "portfolio_load_balancer_hostname" {
  value = kubernetes_service.kube-service-portfolio.status.0.load_balancer.0.ingress.0.hostname
}

# Print out loadbalancer DNS hostname for socks deployment

output "socks_load_balancer_hostname" {
  value = kubernetes_service.kube-service-socks.status.0.load_balancer.0.ingress.0.hostname
}