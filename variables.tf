# Project
variable "google_project" {
  default     = "andersrunningen-test"
  description = "Project ID"
}

variable "google_region" {
  default = "europe-west1"
}

variable "google_zone" {
  default = "europe-west1-b"
}


# GKE
variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

variable "cluster_version" {
  default = "1.17.9-gke.6300"
}