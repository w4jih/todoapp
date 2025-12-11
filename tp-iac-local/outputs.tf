output "application_url" {
  description = "URL to access the Spring Boot ToDo App"
  value       = "http://localhost:${var.app_port_external}"
}

output "postgres_connection" {
  description = "PostgreSQL connection string"
  value       = "postgresql://${var.db_user}:${var.db_password}@localhost:${var.db_port_external}/${var.db_name}"
  sensitive   = true
}

output "docker_network" {
  description = "Docker network created for the app"
  value       = docker_network.app_network.name
}
