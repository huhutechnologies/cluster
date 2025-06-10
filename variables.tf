variable "project_id" {
  description = "The project ID where the cluster will be created"
  type        = string
}

variable "acg_sa_email" {
  description = "The SA email from ACG"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "region" {
  description = "The region of deployment"
  type        = string
}
