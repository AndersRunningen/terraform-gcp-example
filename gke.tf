# # GKE cluster
# resource "google_container_cluster" "primary" {
#   name     = "${var.google_project}-gke"
#   location = var.google_zone

#   remove_default_node_pool = true
#   initial_node_count       = 1

#   min_master_version = var.cluster_version

#   network    = google_compute_network.vpc.name
#   subnetwork = google_compute_subnetwork.subnet.name

#   master_auth {
#     username = var.gke_username
#     password = var.gke_password

#     client_certificate_config {
#       issue_client_certificate = false
#     }
#   }
# }

# # Separately Managed Node Pool
# resource "google_container_node_pool" "primary_nodes" {
#   name       = "${google_container_cluster.primary.name}-node-pool"
#   location   = var.google_zone
#   cluster    = google_container_cluster.primary.name
#   node_count = var.gke_num_nodes

#   node_config {
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#     ]

#     labels = {
#       env = var.google_project
#     }

#     preemptible  = true
#     machine_type = "n1-standard-1"
#     tags         = ["gke-node", "${var.google_project}-gke"]
#     metadata = {
#       disable-legacy-endpoints = "true"
#     }
#   }
# }