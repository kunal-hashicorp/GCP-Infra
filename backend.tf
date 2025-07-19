# backend.tf

terraform {
  backend "gcs" {
    bucket = "ks1-terraform-state-bucket"
    prefix = "terraform/state"
  }
}
