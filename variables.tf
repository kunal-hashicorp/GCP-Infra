variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
}

variable "instance_type" {
  description = "GCE machine type"
  type        = string
  default     = "e2-standard-4"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 50
}

variable "dns_zone_name" {
  description = "Name of the existing Cloud DNS zone"
  type        = string
}

variable "dns_domain" {
  description = "Base domain of your DNS zone (e.g. kunalsingh-17b577.gcp.sbx.hashicorpdemo.com)"
  type        = string
}

variable "dns_record_name" {
  description = "The subdomain name to create under the DNS zone"
  type        = string
}

variable "dns_record_ttl" {
  description = "TTL (Time to Live) for the DNS record"
  type        = number
  default     = 300  # Optional: set a reasonable default
}

variable "bucket" {
  description = "GCS bucket for storing Terraform state"
  type        = string
}
