# main.tf

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

resource "google_compute_firewall" "allow_ssh_http_https" {
  name    = "terraform-allow"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "8080"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  target_tags = ["terraform-vm"]
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
    access_config {}  # Enables external IP for SSH
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata = {
    ssh-keys = "jenkins:${file("${path.module}/keys/jenkins_gcp_key.pub")}"
  }

  tags = ["terraform-vm"]
}

output "instance_public_ip" {
  description = "Public IP of the created VM"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
