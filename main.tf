resource "google_compute_network" "network" {
  name                    = "network-name"
  auto_create_subnetworks = "false"
  project                 = var.google_project
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "subnetwork"
  ip_cidr_range = "10.165.0.0/22"
  project       = var.google_project
  region        = var.google_region
  network       = google_compute_network.network.self_link
}