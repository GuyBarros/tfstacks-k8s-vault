variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  
}

variable "deploy_vault" {
  description = "Whether to deploy Vault"
  type        = string
  default     = "false"
  
}
resource "helm_release" "vault" {
  count    = var.deploy_vault == "true" ? 1 : 0
  name       = "vault"
  namespace  = "vault"
  chart      = "vault"
  repository = "https://helm.releases.hashicorp.com"
  version    = "0.24.0"  # Specify the desired Vault chart version

  create_namespace = true

  values = [
    <<EOF
server:
  dev:
    enabled: true
    rootToken: "root"
  ha:
    enabled: true
  dataStorage:
    enabled: true
    storageClass: "gp2"
    accessMode: "ReadWriteOnce"
    size: "10Gi"
  service:
    type: LoadBalancer

ui:
  enabled: true
EOF
  ]
}


data "kubernetes_service" "vault_service" {
  count    = var.deploy_vault == "true" ? 1 : 0

  metadata {
    name      = "vault"          # Name of the service created by Helm
    namespace = helm_release.vault[count.index].namespace
  }
}
output "vault_service_loadbalancer_hostname" {
 
##  value = data.kubernetes_service.vault_service[*].status[0].load_balancer[0].ingress[0].hostname
  description = "The external hostname of the Vault service (if provided)."
    value = join(", ", [for svc in data.kubernetes_service.vault_service : svc.status[0].load_balancer[0].ingress[0].hostname])

}