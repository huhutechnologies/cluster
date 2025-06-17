# output the gcloud project_id 
output "gcp_project" {
  value       = data.google_client_config.default.project
  description = "The GCloud project id."
}

output "cluster_endpoint" {
  value       = module.gke_simple.cluster_endpoint
  description = "The cluster endpoint."
}

output "gc_artifact_registry_url" {
  value       = module.artifact_registry.repository_url
  description = "The Artifact Registry url."
}

output "region" {
  value       = var.region
  description = "The GCP region."
}

output "cloudbuild_trigger_id" {
  value       = module.cloudbuild_trigger_local_source.trigger_id
  description = "The cloudbuild trigger id."
}
