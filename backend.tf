# backend.tf

terraform {
  backend "gcs" {
    bucket = "ks2-terraform-state-bucket"
    prefix = "terraform/state"
  }
}
