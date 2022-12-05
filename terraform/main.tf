terraform {
  backend "gcs" {
    bucket  = "gcf-sources-279091920414-us-central1"
    # prefix  = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.44.1"
    }
  }
}

data "google_project" "project" {
  project_id = var.project
}

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_dns_record_set" "hello" {
  name = "hello.yokishava.dev."
  type = "A"
  ttl = 3600

  managed_zone = var.managed_zone

  rrdatas = ["199.36.158.100"]
}

resource "google_dns_record_set" "welcome" {
  name = "welcome.yokishava.dev."
  type = "A"
  ttl  = 3600

  managed_zone = var.managed_zone

  rrdatas = ["199.36.158.100"]
}

resource "google_dns_record_set" "nameserver" {
  name = "yokishava.dev."
  type = "NS"
  ttl  = 21600

  managed_zone = var.managed_zone

  rrdatas = [
    "ns-cloud-b1.googledomains.com.",
    "ns-cloud-b2.googledomains.com.",
    "ns-cloud-b3.googledomains.com.",
    "ns-cloud-b4.googledomains.com."
  ]
}

resource "google_dns_record_set" "soa" {
  name = "yokishava.dev."
  type = "SOA"
  ttl  = 21600

  managed_zone = var.managed_zone

  rrdatas = [
    "ns-cloud-b1.googledomains.com. cloud-dns-hostmaster.google.com. 3 21600 3600 259200 300"
  ]
}
