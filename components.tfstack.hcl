
component "eks" {
    source = "./modules/eks"
    providers = {
        aws = provider.aws.main
        tls= provider.tls.name
        time= provider.time.name
        null= provider.null.name
        cloudinit= provider.cloudinit.name
    }
    inputs = {
      cluster_name = var.cluster_name
      region = var.region
      cidr_block = var.cidr_block
      public_subnets = var.public_subnets
      private_subnets = var.private_subnets
    }
}


component "helm" {
  source = "./modules/helm"
  providers = {
    kubernetes = provider.kubernetes.kubernetes
    helm = provider.helm.helm
  }
  inputs = {
    cluster_name = var.cluster_name
    deploy_vault = var.deploy_vault
  }
}

component "vault" {

  source = "./modules/vault"
  providers = {
    vault = provider.vault.this
  }
  inputs = {
    cluster_name = var.cluster_name
    deploy_vault = var.deploy_vault
    postgres_service_url = component.postgreSQL.postgres_service_url
  }
}
component "postgreSQL" {

    source = "./modules/postgreSQL"
    providers = {
        kubernetes = provider.kubernetes.kubernetes
    }
}
