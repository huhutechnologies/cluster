provider "google" {
  project = var.project_id
  region  = "europe-west4"
}

data "google_service_account" "acg_sa" {
  account_id = var.acg_sa_email
}

data "google_client_config" "default" {}
