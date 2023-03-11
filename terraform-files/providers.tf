# AWS provider

# provider "aws" {
#   region     = var.region
#   access_key = var.accesskey
#   secret_key = var.secretkey

# }

terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}