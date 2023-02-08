variable "cluster_count" {
  type        = number
  description = "(Optional) Number of clusters to create. Default is 1."
  default     = 1
}

variable "location" {
  type        = string
  description = "(Optional) The location/region where the cluster will be created. Default is westus."
  default     = "westus"
}

variable "naming_prefix" {
  type        = string
  description = "(Optional) The prefix to use for the cluster name. Defaut is 'rob'."
  default     = "rob"
}

variable "helm_values_path" {
  type        = string
  description = "(Required) The path to the helm values file."
}