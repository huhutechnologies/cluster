variable "project_id" {
  description = "The project ID where the cluster will be created."
  type        = string
}

variable "acg_sa_email" {
  description = "The SA email from ACG."
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster."
  type        = string
}

variable "region" {
  description = "The region of deployment."
  type        = string
}

variable "gc_artifact_registry" {
  description = "The name of the artifact registry to create in Google Cloud."
  type        = string
}

variable "repo_uri" {
  description = "The URI of the local Cloud Source Repo to build"
  type        = string
}


