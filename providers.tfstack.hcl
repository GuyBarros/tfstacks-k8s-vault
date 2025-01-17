required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.59.0"
  }
  kubernetes = {
    source  = "hashicorp/kubernetes"
    version = "~> 2.32.0"
  }
   vault = {
     source  = "hashicorp/vault"
     version = "~> 4.5.0"
   }
  helm = {
    source = "hashicorp/helm"
    version = "~> 2.0.0"
  }
  tls = {
    source = "hashicorp/tls"
    version = "~> 3.0"
  }
  time = {
    source = "hashicorp/time"
    version = "~> 0.7"
  }
  null = {
    source = "hashicorp/null"
    version = "~> 3.0"
  }
  cloudinit = {
    source = "hashicorp/cloudinit"
    version = "~> 2.0"
  }
}
provider "aws" "main" {
  config {
    region = var.region
    
    assume_role_with_web_identity {
      role_arn           = var.role_arn
      web_identity_token = var.identity_token
    }

    default_tags {
      tags = var.default_tags
    }
  }
}
provider "kubernetes" "kubernetes"{
  config {
    host                   = component.eks.module_eks_endpoint
    cluster_ca_certificate = base64decode(component.eks.module_eks_ca_base64)
    token                  = component.eks.module_eks_token 
}
}
provider "helm" "helm" {

  config {
    kubernetes {
      host                   = component.eks.module_eks_endpoint
      cluster_ca_certificate = base64decode(component.eks.module_eks_ca_base64)
      token                  = component.eks.module_eks_token
    }
  }
}
provider "vault" "this" {
   
  config {
    address = "http://${component.helm.vault_service_loadbalancer_hostname}:8200"
    token   = "root"
    namespace= "admin"
  }
  
}

provider "tls" "name" {
}
provider "time" "name" {
}
provider "null" "name" {
}
provider "cloudinit" "name" {
  
}
