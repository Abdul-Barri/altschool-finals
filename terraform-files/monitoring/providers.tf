# AWS provider

provider "aws" {
  region     = "us-east-1"
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

terraform {
  backend "s3" {
    bucket = "terraform-state-08174509694"
    key = "global/prometheus-final/terraform.tfstate"
    region     = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt = true
  }
}

# Kubernetes provider configuration

# Retrieve eks cluster using data source

data "aws_eks_cluster" "eks-cluster" {
  name = "eks-cluster"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority[0].data)
  version          = "2.16.1"

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks-cluster.name]
    command     = "aws"
  }
}

# Kubectl provider configuration

provider "kubectl" {
  host                   = data.aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks-cluster.name]
    command     = "aws"
  }
}

# Retrieve EKS cluster authentication token

data "aws_eks_cluster_auth" "eks-token" {
  name = "eks-cluster"
}

# Heml provider configuration

provider "helm" {
  kubernetes {
  host                   = data.aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.eks-token.token

  }
 
}
