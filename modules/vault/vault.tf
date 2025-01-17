
# # data "vault_kv_secret_v2" "example_secret" {
# #   mount = "secret-k8s"
# #   name = "exampleapp/config"
# # }

# output "my_secret_value" {
#   value = data.vault_kv_secret_v2.example_secret.data["password"]
#   sensitive = true
# }

variable "deploy_vault" {
  type    = string
  default = "false"
  
}

variable "postgres_service_url" {
  type = string
  
}
resource "vault_generic_secret" "example" {
  count    = var.deploy_vault == "true" ? 1 : 0

  path = "secret/foo"

  data_json = jsonencode(
    {
      "foo"   = "bar",
      "pizza" = "cheese"
    }
  )
}

resource "vault_mount" "database" {
  count = var.deploy_vault == "true" ? 1 : 0
  path  = "mydb"
  type  = "database"
}

resource "vault_database_secret_backend_connection" "postgresql" {
  count    = var.deploy_vault == "true" ? 1 : 0
  backend   = "mydb"
  name      = "postgresql-database"
  plugin_name = "postgresql-database-plugin"
  allowed_roles = ["readonly-role","admin-role"]
  postgresql {
    connection_url = "postgresql://{{username}}:{{password}}@${var.postgres_service_url}:5432/mydb?sslmode=disable"
    username = "user"
    password = "123"
  }
}


resource "vault_database_secret_backend_role" "readonly_role" {
  count   = var.deploy_vault == "true" ? 1 : 0
  backend = "mydb"
  name    = "readonly-role"
  db_name = "postgresql-database"
  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}';", 
    "GRANT CONNECT ON DATABASE mydb TO \"{{name}}\";", 
    "GRANT USAGE ON SCHEMA public TO \"{{name}}\";",                
    "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"  
  ]
  default_ttl = "1"  
  max_ttl     = "24" 
}


resource "vault_database_secret_backend_role" "admin" {
  count   = var.deploy_vault == "true" ? 1 : 0
  backend = "mydb"
  name    = "admin-role"
  db_name = "postgresql-database"
  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}';",
    "GRANT ALL PRIVILEGES ON DATABASE mydb TO \"{{name}}\";",
    "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO \"{{name}}\";",
    "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO \"{{name}}\";",
    "ALTER ROLE \"{{name}}\" WITH SUPERUSER CREATEDB CREATEROLE;"
  ]


  default_ttl = "1"
  max_ttl     = "24"
}

