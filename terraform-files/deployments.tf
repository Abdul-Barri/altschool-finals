# Data resource referencing eks cluster created

# data "aws_eks_cluster" "my_cluster" {
#   name = "eks-cluster-portfolio"
# }

# Kubernetes provider configuration

provider "kubernetes" {
  # host                   = data.aws_eks_cluster.my_cluster.endpoint
  # cluster_ca_certificate = base64decode(data.aws_eks_cluster.my_cluster.certificate_authority[0].data)
  # version          = "2.16.1"

  # exec {
  #   api_version = "client.authentication.k8s.io/v1alpha1"
  #   args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.my_cluster.name]
  #   command     = "aws"
  # }
}

# Kubectl provider configuration

provider "kubectl" {
  # host                   = data.aws_eks_cluster.my_cluster.endpoint
  # cluster_ca_certificate = base64decode(data.aws_eks_cluster.my_cluster.certificate_authority[0].data)
  # exec {
  #   api_version = "client.authentication.k8s.io/v1alpha1"
  #   args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.my_cluster.name]
  #   command     = "aws"
  # }
}

# Create kubernetes Name space

resource "kubernetes_namespace" "kube-namespace" {
  metadata {
    name = "portfolio-namespace"
    labels = {
      app = var.application-name
    }
  }
}

# # Create kubernetes deployment

# resource "kubernetes_deployment" "kube-deployment" {
#   metadata {
#     name      = var.application-name
#     namespace = kubernetes_namespace.kube-namespace.id
#     labels = {
#       app = var.application-name
#     }
#   }

#   spec {
#     replicas = 2
#     selector {
#       match_labels = {
#         app = var.application-name
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = var.application-name
#         }
#       }
#       spec {
#         container {
#           image = var.image
#           name  = var.application-name
#         }
#       }
#     }
#   }
# }

# # Create kubectl deployment

# resource "kubectl_manifest" "kube-deployment" {
#     yaml_body = <<YAML
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: ${var.application-name}
#   namespace: portfolio-namespace
#   labels:
#     app: ${var.application-name}
# spec:
#   replicas: 2
#   selector:
#     matchLabels:
#       app: ${var.application-name}
#   template:
#     metadata:
#       labels:
#         app: ${var.application-name}
#     spec:
#       containers:
#       - name: ${var.application-name}
#         image: ${var.image}
#         ports:
#         - containerPort: 80
# YAML
# }

# # Create kubectl service

# resource "kubectl_manifest" "kube-service" {
#     depends_on = [kubectl_manifest.kube-deployment]
#     yaml_body = <<YAML
# apiVersion: v1
# kind: Service
# metadata:
#   name: ${var.application-name}
#   namespace: portfolio-namespace
# spec:
#   selector:
#     app: ${var.application-name}
#   type: LoadBalancer
#   ports:
#   - name: http
#     port: 80
#     targetPort: 80
# YAML
# }

# # Create kubernetes service

# resource "kubernetes_service" "kube-service" {
#   metadata {
#     name      = var.application-name
#     namespace = kubernetes_namespace.kube-namespace.id
#   }
#   spec {
#     selector = {
#       app = kubernetes_deployment.kube-deployment.metadata[0].labels.app
#     }
#     port {
#       port        = 8080
#       target_port = 80
#     }
#     type = "LoadBalancer"
#   }
# }