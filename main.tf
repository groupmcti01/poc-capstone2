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

resource "google_service_account" "service_account" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_cloud_scheduler_job" "mcit-capstone2-scheduler-workflow-poc" {
  project           =   var.project_id
  name              =   "mcit-capstone2-scheduler-workflow-export"
  description       =   "Cron job for workflows mctit-capstone2-workflow-poc"
  schedule          =   "* 1 * * *"
  time_zone         =   "America/New_York"
  attempt_deadline  =   "320s"
  region            =   var.location


  http_target {
    http_method     =   "POST"
    uri             =   "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.mcti-capstone2-workflow-poc.id}/executions"
    #uri            =   "https://workflowexecutions.googleapis.com/v1/projects/mcti-project/locations/northamerica-northeast1/workflows/capston2-mcti-workflow-testing/executions"
    body = base64encode(
      jsonencode({
        "argument" : null,
        "callLogLevel" : "CALL_LOG_LEVEL_UNSPECIFIED"
        }
    ))

  oauth_token {
    service_account_email   = data.google_compute_default_service_account.default.email
    scope                   = "https://www.googleapis.com/auth/cloud-platform"
  }
  }
}

resource "google_workflows_workflow" "mcti-capstone2-workflow-poc" {
  name            = "mctit-capstone2-workflow-poc"
  region          = var.location
  description     = "Export firestore data"
  service_account = "google_service_account.service_account.id"
  labels = {
    env = "poc"
  }
  project         = var.project_id
  source_contents = templatefile("${path.root}/yamls/export.yaml",{})
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
}

resource "google_project_service" "mctit-capstone2-firestore-poc" {
  project 	= var.project_id
  service 	= "firestore.googleapis.com"

  depends_on 	= [time_sleep.wait_60_seconds]
}

resource "google_firestore_database" "database" {
  project     			        = var.project_id
  name        			        = "(default)"
  location_id 			        = "northamerica-northeast1"
  type        			        = "FIRESTORE_NATIVE"
  concurrency_mode		        = "OPTIMISTIC"
  app_engine_integration_mode 	= "DISABLED"

  depends_on 			= [google_project_service.mctit-capstone2-firestore-poc]
}

