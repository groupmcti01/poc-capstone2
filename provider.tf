terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.57.0"
    }
  }
}

provider "google" {
  project     = "mcti-capstone2-testing "
  region      = "northamerica-northeast1"
}


terraform {
  cloud {
    organization = "mcti-group"

    workspaces {
      name = "poc-capstone2"
    }
  }
}
