variable "dns_record_name" {
  type        = string
  description = "Subdomain for the DNS record (leave empty for root record)"
  default     = ""
}

variable "dns_record_ttl" {
  type        = number
  description = "TTL for the DNS record"
  default     = 300
}

resource "google_dns_record_set" "a_record" {
  # Build record name safely, strip extra dots
  name = trim(
    "${var.dns_record_name != "" ? "${var.dns_record_name}." : ""}kunalsingh-ee7c5e.gcp.sbx.hashicorpdemo.com",
    "."
  )

  type         = "A"
  ttl          = var.dns_record_ttl
  managed_zone = "doormat-useremail"

  rrdatas = [
    google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
  ]
}
