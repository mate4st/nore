data "docker_registry_image" "vault" {
  name = "vault:latest"
}

resource "docker_image" "vault" {
  name = data.docker_registry_image.vault.name
  pull_triggers = [
    data.docker_registry_image.vault.sha256_digest]
}

resource "docker_container" "vault" {
  name = "vault"
  image = docker_image.vault.latest

  labels {
    label = "traefik.http.routers.vault.rule"
    value = "Host(`vault.ando.arda`)"
  }

  labels {
    label = "traefik.http.routers.vault.tls"
    value = "true"
  }

  labels {
    label = "traefik.http.services.vault.loadbalancer.server.port"
    value = "8200"
  }

  labels {
    label = "traefik.enable"
    value = "true"
  }

  command = [
    "server"
  ]

  mounts {
    target = "/vault/config"
    source = "/opt/services/vault/config"
    type = "bind"
  }

  mounts {
    target = "/vault/file"
    source = "/opt/services/vault/file"
    type = "bind"
  }

  # vault logs
  mounts {
    target = "/vault/logs"
    source = "/opt/services/vault/logs"
    type = "bind"
  }

  capabilities {
    add  = ["IPC_LOCK"]
  }

  networks_advanced {
    name = var.traefik_network
  }

  restart = "unless-stopped"
  must_run = true

}
