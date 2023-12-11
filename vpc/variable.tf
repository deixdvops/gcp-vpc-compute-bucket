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

