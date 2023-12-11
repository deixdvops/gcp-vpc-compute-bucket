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
variable "os_image" {
  default = "ubuntu-2004-focal-v20231130"

}

variable "vm_params" {
  type = object({
    name                      = string
    machine_type              = string
    zone                      = string
    allow_stopping_for_update = bool
  })
  description = "vm parameters to set the name, machine type, zone and update"
  default = {
    name                      = "terraform-jenkins"
    machine_type              = "c3-standard-4"
    zone                      = "us-central1-a"
    allow_stopping_for_update = true
  }
  validation {
    condition     = length(var.vm_params.name) > 3
    error_message = "vm name must be at least 4 characters"
  }
}