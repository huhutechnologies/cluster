# output the gcloud project_id 
output "gcp_project" {
  value       = data.google_client_config.default.project
  description = "The GCloud project id."
}

output "cluster_endpoint" {
  value       = module.gke_simple.cluster_endpoint
  description = "The cluster endpoint."
}
