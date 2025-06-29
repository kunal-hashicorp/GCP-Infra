terraform {
  backend "gcs" {
    bucket = "gcp-terraform-state-bucket"   # Replace with your actual bucket name
    prefix = "terraform/state"
  }
}
