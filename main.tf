# main.tf

terraform {
  backend "gcs" {
    bucket = "ks-terraform-state-bucket"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

data "google_compute_image" "custom_image" {
  name    = "ubuntu-pro-2004-focal-v20250425"
  project = "ubuntu-os-pro-cloud"
}

resource "google_service_account" "vm_sa" {
  account_id   = "vm-service-account"
  display_name = "VM Service Account"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-vm"
  machine_type = var.instance_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.custom_image.self_link
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["terraform-vm"]
}

output "instance_public_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
