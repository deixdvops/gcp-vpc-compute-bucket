
resource "google_compute_network" "terra_network" {
  name                    = "deix-devops-terra"
  auto_create_subnetworks = false

}

resource "google_compute_subnetwork" "terra-subnet1" {
  name          = "deix-devops-terra-subnet1"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.terra_network.id

}
