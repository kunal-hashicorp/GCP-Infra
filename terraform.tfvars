# terraform.tfvars

gcp_project       = "hc-694f54fc6dd944dbbb1e2f854f3"
gcp_region        = "us-central1"
gcp_zone          = "us-central1-a"
instance_type     = "e2-medium"
boot_disk_size_gb = 20

dns_zone_name     = "kunalsingh-zone"
dns_domain        = "kunalsingh-17b577.gcp.sbx.hashicorpdemo.com"
dns_record_name   = "ks-fdo-test"
dns_record_ttl    = 3600

db_name     = "postgres-instance"
db_user     = "postgres"
db_password = ""
db_tier     = "db-n1-standard-16"

bucket_name = "ks1-terraform-vm-bucket"
