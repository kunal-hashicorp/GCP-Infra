# backend.tf

terraform {
  backend "gcs" {
    bucket = "ks-terraform-state-bucket"
    prefix = "terraform/state"
  }
}
