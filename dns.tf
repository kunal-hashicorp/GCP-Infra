resource "google_dns_record_set" "a_record" {
  name         = "${var.dns_record_name}.${var.dns_domain}."
  type         = "A"
  ttl          = var.dns_record_ttl
  managed_zone = "doormat-useremail"
  rrdatas      = [google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip]
}
