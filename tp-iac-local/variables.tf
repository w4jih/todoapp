#########################
# Application Variables #
#########################

variable "app_port_external" {
  description = "External port for the Spring Boot app"
  type        = number
  default     = 8081
}

##########################
# PostgreSQL Variables   #
##########################

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "todolist_db"
}

variable "db_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "todolist_user"
}

variable "db_password" {
  description = "PostgreSQL password"
  type        = string
  default     = "secret123"
  sensitive   = true
}

variable "db_port_external" {
  description = "External port for PostgreSQL"
  type        = number
  default     = 5433
}
