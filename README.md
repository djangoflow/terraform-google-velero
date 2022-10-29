# Velero on Google Cloud Platform

## Intro

This module installs velero on GKE and creates a GCS bucket with Google SA to use it

## Example

```
module "velero" {
  source          = "djangoflow/velero/google"
  bucket_location = "us-west4"
  bucket_name     = "my-backup-bucket"
  bucket_project  = "my-backup-project"
}
```