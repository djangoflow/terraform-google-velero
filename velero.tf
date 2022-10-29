resource "helm_release" "velero" {
  depends_on = [kubernetes_namespace_v1.velero, google_storage_bucket_iam_binding.bucket-binding-admin]
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  name       = var.name
  namespace  = var.namespace
  values     = [
    <<EOT
image:
  repository: velero/velero
  tag: latest
  pullPolicy: IfNotPresent
resources:
  limits:
    memory: 512Mi
  requests:
    cpu: 100m
    memory: 256Mi
initContainers:
  - name: velero-plugin-for-gcp
    image: velero/velero-plugin-for-gcp:latest
    imagePullPolicy: IfNotPresent
    volumeMounts:
      - mountPath: /target
        name: plugins
configuration:
  provider: gcp
  backupStorageLocation:
    name: default
    bucket: ${google_storage_bucket.bucket.name}
    config:
      serviceAccount: ${local.google_sa}
  logLevel: info
  logFormat: json
serviceAccount:
  server:
    create: true
    name: ${var.service_account}
    annotations:
      iam.gke.io/gcp-service-account: ${module.service_account.email}
credentials:
  useSecret: false
backupsEnabled: true
snapshotsEnabled: true
deployRestic: false

# Backup schedules to create.
# Eg:
# schedules:
#   mybackup:
#     schedule: "0 0 * * *"
#     template:
#       ttl: "240h"
#       includedNamespaces:
#        - foo
EOT
  ]
}
