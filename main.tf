module "gke_simple" {
  source       = "../modules/gke_cluster"
  cluster_name = var.cluster_name
  region       = var.region
  node_sa      = var.acg_sa_email
}
