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
