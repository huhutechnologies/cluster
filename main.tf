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

module "cloudbuild_trigger_local_source" {
  source          = "../modules/cloudbuild_trigger_local_source"
  trigger_name    = "local-source-trigger"
  repo_name       = "quickstart-docker"
  buildfile_path  = "cloudbuild.yaml"
  region          = var.region
  project_id      = var.project_id
  service_account = var.acg_sa_email
}
