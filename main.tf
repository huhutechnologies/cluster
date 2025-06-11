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
