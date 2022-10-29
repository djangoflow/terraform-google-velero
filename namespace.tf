resource "kubernetes_namespace_v1" "velero" {
  metadata {
    name = var.namespace
  }
}
