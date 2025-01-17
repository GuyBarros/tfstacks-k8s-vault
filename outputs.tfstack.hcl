output "vault_url" {
  type = string
  value = "http://${component.helm.vault_service_loadbalancer_hostname}:8200"
  
}

output "module_eks_token" {
  value = component.eks.module_eks_token
  type = string
  sensitive = true
}

output "module_eks_endpoint" {
  value = component.eks.module_eks_endpoint
  type = string
}

output "module_eks_ca_base64" {
  value = component.eks.module_eks_ca_base64  
  type = string
}

output "postgres_service_url" {
  value = "http://${component.postgreSQL.postgres_service_url}:8200"
  type = string
}