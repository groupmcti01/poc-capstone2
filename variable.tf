# name project 
variable "project_id" {
  type        =   string
  description =   "Project Name"
  default     =   "mcti-capstone2-testing"
}

# region
variable "location" {
  type          =   string
  description   =   "bucket region"
  default       =   "northamerica-northeast1"
}

variable "apis_state" {
    type        =   string
    description =   "Enable API"
    default     =   true
}

variable "service_account_email" {
  description = "Service account email. Unused if service account is auto-created."
  type        = string
  default     = null
}

variable "service_account_create" {
  description = "Auto-create service account."
  type        = bool
  default     = false
}
