data "docker_registry_image" "pyload" {
  name = "linuxserver/pyload"
}

resource "docker_image" "pyload" {
  name = data.docker_registry_image.pyload.name
  pull_triggers = [
    data.docker_registry_image.pyload.sha256_digest]
}

resource "docker_container" "pyload" {
  name = "pyload"
  image = docker_image.pyload.latest

  labels {
    label = "traefik.http.routers.pyload.rule"
    value = "Host(`pyload.ando.arda`)"
  }

  labels {
    label = "traefik.http.routers.pyload.tls"
    value = "true"
  }

  labels {
    label = "traefik.http.services.pyload.loadbalancer.server.port"
    value = "8000"
  }

  labels {
    label = "traefik.enable"
    value = "true"
  }

  mounts {
    target = "/downloads"
    source = "/mnt/p1/pyload"
    type = "bind"
    read_only = false
  }

  mounts {
    target = "/config"
    source = "/opt/services/pyload"
    type = "bind"
    read_only = false
  }

  env = [
    "PUID=1000",
    "PGID=1000",
    "TZ=Europe/London"
  ]

  networks_advanced {
    name = var.traefik_network
  }

  restart = "unless-stopped"
  must_run = true

}
