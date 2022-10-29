resource "google_storage_bucket" "bucket" {
  name                        = var.bucket_name
  location                    = var.bucket_location
  project                     = var.bucket_project
  storage_class               = var.bucket_storage_class
  uniform_bucket_level_access = false
  labels                      = var.bucket_labels
  dynamic "lifecycle_rule" {
    for_each = {for k, v in var.bucket_lifecycle_rules : k => v}
    content {
      condition {
        age        = lifecycle_rule.value.condition.age
        with_state = lifecycle_rule.value.condition.with_state
      }
      action {
        type = lifecycle_rule.value.action.type
      }
    }
  }
  dynamic "encryption" {
    for_each = var.kms_enable ? [1] : []
    content {
      default_kms_key_name = keys(module.kms.keys)[0]
    }
  }
}

resource "google_storage_bucket_iam_binding" "bucket-binding-admin" {
  depends_on = [module.service_account, google_storage_bucket.bucket]
  bucket     = google_storage_bucket.bucket.name
  role       = "roles/storage.objectAdmin"
  members    = [
    "serviceAccount:${module.service_account.email}"
  ]
}