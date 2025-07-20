resource "google_dns_record_set" "a_record" {
  name         = "${var.dns_record_name}.kunalsingh-17b577.gcp.sbx.hashicorpdemo.com."  # ✅ uses tfvars value
  type         = "A"
  ttl          = 3600
  managed_zone = "doormat-useremail"
  rrdatas      = [google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip]
}
