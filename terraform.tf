terraform {
  required_version = ">= 1.3.0"
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.4.0"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}
