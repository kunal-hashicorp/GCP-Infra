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
    ports    = ["22", "80", "443", "8800"]
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
      size  = var.boot_disk_size_gb
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

  metadata = {
    ssh-keys = "jenkins:${file("${path.module}/keys/jenkins_gcp_key.pub")}"
  }

  tags = ["terraform-vm"]
}

resource "google_project_iam_member" "vm_sa_bucket_access" {
  project = var.gcp_project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.vm_sa.email}"
}

resource "google_storage_bucket" "vm_bucket" {
  name     = var.bucket_name
  location = var.gcp_region
}

resource "google_sql_database_instance" "postgres_instance" {
  name             = var.db_name
  database_version = "POSTGRES_15"
  region           = var.gcp_region

  settings {
    tier = var.db_tier
    ip_configuration {
      ipv4_enabled    = true
      authorized_networks {
        name  = "public-access"
        value = "0.0.0.0/0"
      }
    }
    backup_configuration {
      enabled = true
    }
  }

  deletion_protection = false
}

resource "google_sql_user" "db_user" {
  name     = var.db_user
  instance = google_sql_database_instance.postgres_instance.name
  password = var.db_password
}

resource "google_sql_database" "default" {
  name     = "defaultdb"
  instance = google_sql_database_instance.postgres_instance.name
}
