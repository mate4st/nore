resource "docker_network" "traefik_net" {
  name = "traefik_net"
  //  ipv6 = true
  //
  //  ipam_config {
  //    subnet = "2a01:4f8:221:3e41::2:0/112"
  //  }
  //
  //  lifecycle {
  //    ignore_changes = [
  //      # Ignore changes to ipam_config, e.g. because this forces recreation of the network
  //      # without any changes. This is considered as a bug like the container replacement mentioned in Readme.md
  //      ipam_config,
  //    ]
  //  }
}

data "docker_registry_image" "traefik" {
  name = "traefik:v2.3"
}

resource "docker_image" "traefik" {
  name = data.docker_registry_image.traefik.name
  pull_triggers = [
    data.docker_registry_image.traefik.sha256_digest]
}

resource "docker_container" "traefik" {
  name = "traefik"

  image = docker_image.traefik.latest

  # acme (Let's encrypt) configuration file
  # needs 600 permission
  mounts {
    target = "/acme.json"
    source = "/opt/services/traefik/acme.json"
    type = "bind"
    read_only = false
  }

  # Traefik configuration file
  mounts {
    target = "/etc/traefik/traefik.toml"
    source = "/opt/services/traefik/traefik.toml"
    type = "bind"
    read_only = true
  }

  # Traefik file provider configuration dir
  mounts {
    target = "/etc/traefik/file.d"
    source = "/opt/services/traefik/file.d"
    type = "bind"
    read_only = true
  }

  # Logging
  mounts {
    source = "/var/log/traefik"
    target = "/var/log/traefik"
    type = "bind"
    read_only = false
  }

  # Docker socket
  mounts {
    target = "/var/run/docker.sock"
    source = "/var/run/docker.sock"
    type = "bind"
    read_only = true
  }

  # HTTP
  ports {
    internal = "80"
    external = "80"
    protocol = "tcp"
  }

  # HTTPS
  ports {
    internal = "443"
    external = "443"
    protocol = "tcp"
  }

  # socket.io
  //  ports {
  //    internal = "1337"
  //    external = "1337"
  //    protocol = "tcp"
  //  }

  networks_advanced {
    name = docker_network.traefik_net.name
    //    ipv6_address = "2a01:4f8:221:3e41::2:a2"
  }

  restart = "unless-stopped"
  must_run = true

}
