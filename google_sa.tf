module "service_account" {
  source     = "terraform-google-modules/service-accounts/google"
  project_id = local.project

  names = [
    local.google_sa
  ]
}

module "custom_role" {
  source       = "terraform-google-modules/iam/google//modules/custom_role_iam"
  target_level = "project"
  target_id    = local.project
  role_id      = local.google_sa
  title        = title(local.google_sa)
  description  = format("Role for %s", local.google_sa)
  base_roles   = []

  permissions = [
    "compute.disks.get",
    "compute.disks.create",
    "compute.disks.createSnapshot",
    "compute.snapshots.get",
    "compute.snapshots.create",
    "compute.snapshots.useReadOnly",
    "compute.snapshots.delete",
    "compute.zones.get"
  ]

  excluded_permissions = []

  members = [
    # https://github.com/terraform-google-modules/terraform-google-cloud-storage/issues/142
    # format("serviceAccount:%s", module.service_account.email),
    format("serviceAccount:%s@%s.iam.gserviceaccount.com", local.google_sa, local.project),
  ]

  depends_on = [
    module.service_account
  ]
}

module "iam_service_accounts" {
  source  = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  project = local.project
  mode    = "authoritative"

  service_accounts = [
    # https://github.com/terraform-google-modules/terraform-google-cloud-storage/issues/142
    # module.service_account.email
    format("%s@%s.iam.gserviceaccount.com", local.google_sa, local.project),
  ]

  bindings = {
    "roles/iam.workloadIdentityUser" = [
      format("serviceAccount:%s.svc.id.goog[%s/%s]", local.project, var.namespace, var.service_account)
    ]
  }

  depends_on = [
    module.service_account
  ]
}
