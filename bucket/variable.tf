variable "project" {
  description = "project name"

}
variable "terraform-credentials-file" {
  type        = string
  description = " The GCP service account that Terraform will use to authenticate to the project"
}
variable "region" {
  default     = "us-central1"
  description = "region"
}
variable "zone" {
  default     = "us-central1-a"
  description = "zone"

}

variable "force_destroy" {
  description = "Set to true to allow Terraform to destroy the bucket."
  default     = true
}
variable "versioning_enabled" {
  description = "Enable versioning for the bucket."
  default     = true
}

variable "main_page_suffix" {
  description = "Default page to serve when accessing the root URL of the bucket."
  default     = "index.html"
}

variable "not_found_page" {
  description = "Page to serve when a user requests a page that does not exist."
  default     = "404.html"
}
variable "bucket_name" {
  description = "Name of the Google Cloud Storage bucket."
}