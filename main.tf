terraform {

  backend "s3" {
    bucket = "hb-wolke-edda"
    key    = "terraform/fennas/terraform.tfstate"
    region = "eu-central-1"
  }

  required_providers {
    docker = {
      source = "terraform-providers/docker"
    }
  }
  required_version = ">= 0.13"
}

provider "docker" {
  host = "ssh://ando"

  registry_auth {
    address = "registry.fanya.dev"
    username = "ando"
    password = var.docker_registry_pw
  }
}

module "traefik" {
  source = "./modules/traefik"
}

module "vault" {
  source = "./modules/vault"
  traefik_network = module.traefik.traefik_net
}

module "pyload" {
  source = "./modules/pyload"
  traefik_network = module.traefik.traefik_net
}

module "minio" {
  source = "./modules/minio"
  traefik_network = module.traefik.traefik_net
  minio_secret_key = var.minio_secret_key
}