data "google_client_config" "google" {}

locals {
  project = data.google_client_config.google.project
  google_sa = coalesce(var.google_sa, var.service_account)
}