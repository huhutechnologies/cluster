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

variable "create_connection" {
  description = "Flag to create the connection for the source code"
  type        = bool
}
variable "connection_name" {
  description = "The connection_name to pull the source code for the application to build."
  type        = string
}
variable "github_app_installation_id" {
  description = "The github_app_installation_id to pull the source code for the application to build."
  type        = string
}
variable "github_oauth_token_secret_version" {
  description = "The github_oauth_token_secret_version to pull the source code for the application to build."
  type        = string
}
