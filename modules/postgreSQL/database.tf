resource "kubernetes_namespace" "example" {
  metadata {
    name = "services"
  }
}
resource "kubernetes_service" "db_service" {
  metadata {
    name = "db-service"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      app = "db-app"
    }

    port {
      port        = 5432  # Replace with your database port
      target_port = 5432  # Replace with your database port
    }

    # Change the type to one of the following: ClusterIP, NodePort, LoadBalancer
    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "db_deployment" {
  metadata {
    name = "db-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "db-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "db-app"
        }
      }

      spec {
        container {
          name  = "db-container"
          image = "postgres:latest"  # Replace with your database image

          port {
            container_port = 5432  # Replace with your database port
          }

          env {
            name  = "POSTGRES_DB"
            value = "mydb"  # Replace with your database name
          }

          env {
            name  = "POSTGRES_USER"
            value = "user"  # Replace with your database user
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = "123"  # Replace with your database password
          }
        }
      }
    }
  }
}

output "postgres_service_url" {
 value = try(kubernetes_service.db_service.status.0.load_balancer.0.ingress.0.hostname, "Pending")
  description = "The hostname of the LoadBalancer for the DB service, or 'Pending' if unavailable"
}