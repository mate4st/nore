data "docker_registry_image" "minio" {
  name = "minio/minio:RELEASE.2020-09-23T19-18-30Z-arm64"
}

resource "docker_image" "minio" {
  name = data.docker_registry_image.minio.name
  pull_triggers = [
    data.docker_registry_image.minio.sha256_digest]
}

resource "docker_container" "minio" {
  name = "minio"
  image = docker_image.minio.latest

  labels {
    label = "traefik.http.routers.minio.rule"
    value = "Host(`minio.fanya.dev`)"
  }

  labels {
    label = "traefik.http.routers.minio.entrypoints"
    value = "websecure"
  }

  labels {
    label = "traefik.http.routers.minio.tls"
    value = "true"
  }

  labels {
    label = "traefik.http.routers.minio.tls.certresolver"
    value = "letsencrypt"
  }

  labels {
    label = "traefik.http.services.minio.loadbalancer.server.port"
    value = "9000"
  }

  labels {
    label = "traefik.enable"
    value = "true"
  }

  mounts {
    target = "/data"
    source = "/mnt/p1/minio"
    type = "bind"
    read_only = false
  }

  env = [
    "MINIO_ACCESS_KEY=admin",
    "MINIO_SECRET_KEY=${var.minio_secret_key}",
    "MINIO_DOMAIN=minio.fanya.dev",
    "MINIO_DISK_USAGE_CRAWL_ENABLE=off"
  ]

  command = [
    "server",
    "/data"
  ]

  networks_advanced {
    name = var.traefik_network
  }

  restart = "unless-stopped"
  must_run = true

}
