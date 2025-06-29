provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

data "google_compute_image" "custom_image" {
  name    = "ubuntu-pro-2004-focal-v20250425"
  project = "ubuntu-os-pro-cloud"
}


# Create a service account
resource "google_service_account" "vm_sa" {
  account_id   = "vm-service-account"
  display_name = "VM Service Account"
}

# Assign IAM roles to the service account
/*resource "google_project_iam_member" "sa_role" {
  project = var.gcp_project
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.vm_sa.email}"
}*/

# Create the instance
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
    access_config {} # required for external IP
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["terraform-vm"]
}

# Output the instance's public IP
output "instance_public_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
