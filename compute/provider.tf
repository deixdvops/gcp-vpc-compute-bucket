terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.74.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = file("${var.terraform-credentials-file}")
}