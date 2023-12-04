resource "google_storage_bucket" "capstone2_poc" {
    name = mcti-capstone2-poc
    location = var.location
    project  = var.project_id
    storage_class = "STANDARD"

    uniform_bucket_level_access = true

    lifecycle_rule {
      condition {
        age = 5
      }
      action {
        type = "Delete"
      }
    }

    lifecycle_rule {
      condition {
        age = 2
      }
      action {
        type            = "SetStorageClass"
        storage_class   = "COLDLINE"
      }
    }

    retention_policy {
      is_locked = true
      retention_period = 864000
    }

}
