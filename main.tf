resource "google_storage_bucket" "capstone2_poc" {
    name 		=  "mcti-capstone2-poc"
    location 		= var.location
    project  		= var.project_id
    storage_class 	= "STANDARD"

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

data "google_compute_default_service_account" "default" {
  project = var.project_id
}

resource "google_cloud_scheduler_job" "mcit-capstone2-scheduler-workflow" {
  project           =   var.project_id
  name              =   ""
  description       =   ""
  schedule          =   ""
  time_zone         =   ""
  attempt_deadline  =   ""
  region            =   ""


  http_target {
    http_method     =   "POST"
    uri             =   "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.mcti-capstone2-workflow.id}/executions"

  oauth_token {
    service_account_email   = ""
    scope                   = ""
  }
  }
}

resource "google_workflows_workflow" "workflow" {
  name            = ""
  region          = ""
  description     = ""
  service_account = ""
  project         = ""
  labels          = ""
  source_contents = ""
}