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
          image = var.docker-image
          name  = "portfolio"
          env {
            name  = "MYSQL_HOST"
            value = "mysql"
          }
          env {
            name  = "MYSQL_PORT"
            value = "3306"
          }
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
      name = "metrics"
      port        = 80
      target_port = 80
    }
    port {
      name = "mysql"
      port        = 3306
      target_port = 3306
    }
    type = "LoadBalancer"
  }
}

# MYSQL database for portfolio app

resource "kubernetes_deployment" "portfolio-db" {
  metadata {
    name = "mysql"
    namespace = kubernetes_namespace.kube-namespace-portfolio.id
    labels = {
      app = "mysql"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mysql"
      }
    }
    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name = "mysql"
          image = "mysql:latest"

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value = var.mysql-password
          }

          port {
            name = "mysql"
            container_port = 3306
          }

          volume_mount {
            name = "mysql-persistent-storage"
            mount_path = "/var/lib/mysql"
          }
        }

        volume {
          name = "mysql-persistent-storage"
          empty_dir {
            medium = "Memory"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "porftolio-db-service" {
  metadata {
    name = "mysql"
    namespace = kubernetes_namespace.kube-namespace-portfolio.id
  }

  spec {
    selector = {
      app = "mysql"
    }

    port {
      name = "mysql"
      port = 3306
      target_port = 3306
    }

    type = "ClusterIP"
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
      name = "metrics"
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