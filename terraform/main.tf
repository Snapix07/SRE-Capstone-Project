resource "docker_network" "sre_network" {
  name = var.network_name
}

resource "docker_image" "app" {
  name         = var.app_image
  keep_locally = true
}

resource "docker_image" "prometheus" {
  name         = "prom/prometheus:latest"
  keep_locally = true
}

resource "docker_image" "grafana" {
  name         = "grafana/grafana:latest"
  keep_locally = true
}

resource "docker_container" "app" {
  name  = "sre-capstone-app"
  image = docker_image.app.image_id

  networks_advanced {
    name = docker_network.sre_network.name
  }

  ports {
    internal = 5000
    external = var.app_port
  }

  restart = "unless-stopped"

  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost:5000/health"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 3
    start_period = "10s"
  }
}

resource "docker_container" "prometheus" {
  name  = "sre-prometheus"
  image = docker_image.prometheus.image_id

  networks_advanced {
    name = docker_network.sre_network.name
  }

  ports {
    internal = 9090
    external = var.prometheus_port
  }

  volumes {
    host_path      = abspath("${path.module}/../monitoring/prometheus.yml")
    container_path = "/etc/prometheus/prometheus.yml"
    read_only      = true
  }

  restart = "unless-stopped"
}

resource "docker_container" "grafana" {
  name  = "sre-grafana"
  image = docker_image.grafana.image_id

  networks_advanced {
    name = docker_network.sre_network.name
  }

  ports {
    internal = 3000
    external = var.grafana_port
  }

  env = [
    "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_admin_password}",
    "GF_USERS_ALLOW_SIGN_UP=false"
  ]

  restart = "unless-stopped"
}
