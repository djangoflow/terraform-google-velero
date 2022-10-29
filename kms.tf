data "google_storage_project_service_account" "gcs_account" {
  project = local.project
}

module "kms" {
  source = "terraform-google-modules/kms/google"
  count  = var.kms_enable ? 1 : 0

  project_id     = local.project
  location       = var.kms_keyring_location
  keyring        = var.name
  keys           = var.kms_keys
  set_owners_for = var.kms_keys
  owners         = var.kms_owners
  labels         = var.kms_labels

  encrypters = [
    data.google_storage_project_service_account.gcs_account.email_address
  ]

  decrypters = [
    data.google_storage_project_service_account.gcs_account.email_address
  ]
}
