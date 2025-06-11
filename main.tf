module "artifact_registry" {
  source          = "../modules/gc-artifact-registry"
  repository_name = var.gc_artifact_registry
  region          = var.region

  # You can use module.artifact_registry.gke_registry_config if needed
}


module "gke_simple" {
  source       = "../modules/gke-cluster"
  cluster_name = var.cluster_name
  region       = var.region
  node_sa      = var.acg_sa_email
}

module "cloudbuild_trigger" {
  source         = "../modules/cloudbuild-trigger"
  trigger_name   = "quickstart-docker-trigger"
  repository     = "application"
  branch         = "main"
  region         = var.region
  project_id     = var.project_id
  included_files = ["terraform-module/quickstart-docker/**"]
  buildfile_path = "terraform-module/quickstart-docker/cloudbuild.yaml"

  # GitHub connection configuration
  create_connection                 = var.create_connection
  connection_name                   = var.connection_name
  github_app_installation_id        = var.github_app_installation_id
  github_oauth_token_secret_version = var.github_oauth_token_secret_version
}
