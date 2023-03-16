# AWS provider

provider "aws" {
  region     = "us-east-1"
  # access_key = var.accesskey
  # secret_key = var.secretkey

}

# Kubectl Terraform provider

terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

# Terraform Cloud Eks Workspace

# terraform {
#   cloud {
#     organization = "Abdul-Barri"

#     workspaces {
#       name = "infrastructure"
#     }
#   }
# }

terraform {
  backend "s3" {
    bucket = "terraform-state-08174509694"
    key = "global/infrastructure/terraform.tfstate"
    region     = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt = true
  }
}

# Kubernetes provider configuration

provider "kubernetes" {
  host                   = aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority[0].data)
  version          = "2.16.1"

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks-cluster.name]
    command     = "aws"
  }
}

# Kubectl provider configuration

provider "kubectl" {
  host                   = aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks-cluster.name]
    command     = "aws"
  }
}
