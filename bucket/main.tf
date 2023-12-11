#bucket to store webisite(object)
resource "google_storage_bucket" "bucket-gcp" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = var.force_destroy # Setting this to true allows Terraform to destroy the bucket

  versioning {
    enabled = var.versioning_enabled
  }

  website {
    main_page_suffix = var.main_page_suffix
    not_found_page   = var.not_found_page
  }
}
#make new object public
resource "google_storage_object_access_control" "public_rule" {
  object = google_storage_bucket_object.static_site_src.name
  bucket = google_storage_bucket.bucket-gcp.name
  role   = "READER"
  entity = "allUsers"
}


#upload the html file to the bucket
resource "google_storage_bucket_object" "static_site_src" {
  name   = "index.html"
  source = "../website/index.html"
  bucket = google_storage_bucket.bucket-gcp.name
}

# reserve a static ip address
resource "google_compute_global_address" "website_ip" {
  name = "website-lb-ip"
}

# get the managed DNS zone
data "google_dns_managed_zone" "dns_zone" {
  name = "deixdevops-example"

}

#add the reserved ip to dns
resource "google_dns_record_set" "website" {
  name         = "website.${data.google_dns_managed_zone.dns_zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.dns_zone.name
  rrdatas      = [google_compute_global_address.website_ip]

}

#add the bucket as CDN backend
resource "google_compute_backend_bucket" "website_backend" {
  name        = "website-bucket"
  description = "static car web"
  bucket_name = google_storage_bucket.bucket-gcp.name
  enable_cdn  = true
}
# GCP url map
resource "google_compute_url_map" "webisite" {
  name        = "website-url-map"
  description = "a description"

  default_service = google_compute_backend_bucket.website_backend.self_link
  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_bucket.website_backend.self_link
  }
}

## GCP HTTP proxy
resource "google_compute_target_http_proxy" "webisite" {
  name    = "website-target-proxy"
  url_map = google_compute_url_map.webisite.self_link
}
#GCP forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "website-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.webisite.self_link
  ip_address            = google_compute_global_address.website_ip.address
}