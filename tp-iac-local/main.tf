############################################
# Terraform Provider Configuration         #
############################################

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

############################################
# Docker Network                           #
############################################

resource "docker_network" "app_network" {
  name = "todo-network"
}

############################################
# PostgreSQL Database Container            #
############################################

resource "docker_image" "postgres_image" {
  name         = "postgres:latest"
  keep_locally = true
}

resource "docker_container" "postgres_container" {
  name  = "postgres-db"
  image = docker_image.postgres_image.image_id

  networks_advanced {
    name = docker_network.app_network.name
  }

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]

  ports {
    internal = 5432
    external = var.db_port_external
  }
}

############################################
# Spring Boot Application Container        #
############################################

resource "docker_image" "app_image" {
  name = "todo-app:latest"

  build {
    context    = "."
    dockerfile = "Dockerfile_app"
  }
}

resource "docker_container" "app_container" {
  name  = "springboot-todo"
  image = docker_image.app_image.image_id

  depends_on = [
    docker_container.postgres_container
  ]

  networks_advanced {
    name = docker_network.app_network.name
  }

  env = [
    "SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-db:5432/${var.db_name}",
    "SPRING_DATASOURCE_USERNAME=${var.db_user}",
    "SPRING_DATASOURCE_PASSWORD=${var.db_password}",
    "SPRING_JPA_HIBERNATE_DDL_AUTO=update"
  ]

  ports {
    internal = 8080
    external = var.app_port_external
  }
}
