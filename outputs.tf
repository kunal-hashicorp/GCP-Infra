output "instance_public_ip" {
  description = "The public IP address of the VM"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "instance_private_ip" {
  description = "The private IP address of the VM"
  value       = google_compute_instance.vm_instance.network_interface[0].network_ip
}

output "dns_full_record" {
  value = trimsuffix("${var.dns_record_name}.kunalsingh-17b577.gcp.sbx.hashicorpdemo.com.", ".")
}
