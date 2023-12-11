data "google_compute_network" "my-network" {
  name = "deix-devops-terra"
}
data "google_compute_subnetwork" "my-subnetwork" {
  name   = "deix-devops-terra-subnet1"
  region = "us-central1"
  
}

resource "google_compute_instance" "jenkins-2" {
  name                      = var.vm_params.name
  machine_type              = var.vm_params.machine_type
  zone                      = var.vm_params.zone
  allow_stopping_for_update = var.vm_params.allow_stopping_for_update
  tags                      = ["dev", "test"]
  boot_disk {
    initialize_params {
      image = var.os_image
    }
  }
  network_interface {
    network    = data.google_compute_network.my-network.self_link
    subnetwork = data.google_compute_subnetwork.my-subnetwork.self_link
    access_config {
      //Ephemeral public IP
    }
  }
}