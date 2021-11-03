terraform {
  required_providers {
    google      = "~> 4.0.0"
    google-beta = "~> 3"
  }
}

provider "google" {
  project = var.google_project
  region  = var.google_region
  zone    = var.google_zone
}

provider "google-beta" {
  project = var.google_project
  region  = var.google_region
  zone    = var.google_zone
}