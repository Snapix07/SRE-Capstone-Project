variable "app_image" {
  description = "Docker image for the SRE Capstone app"
  type        = string
  default     = "ghcr.io/snapix07/sre-capstone-project:latest"
}

variable "app_port" {
  description = "Port exposed by the app container"
  type        = number
  default     = 5000
}

variable "prometheus_port" {
  description = "Port exposed by Prometheus"
  type        = number
  default     = 9090
}

variable "grafana_port" {
  description = "Port exposed by Grafana"
  type        = number
  default     = 3000
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "network_name" {
  description = "Docker network name"
  type        = string
  default     = "sre-network"
}
