provider "helm" {
  alias = "cluster1"
  kubernetes {
    host                   = module.clusters[0].host
    client_certificate     = base64decode(module.clusters[0].client_certificate)
    client_key             = base64decode(module.clusters[0].client_key)
    cluster_ca_certificate = base64decode(module.clusters[0].cluster_ca_certificate)
  }
}

# Deploy Robusta and Prometheus to cluster 1
resource "helm_release" "robusta1" {
  provider   = helm.cluster1
  name       = "robusta"
  repository = "https://robusta-charts.storage.googleapis.com"
  chart      = "robusta"

  values = [
    "${file(var.helm_values_path)}"
  ]

  set {
    name  = "clusterName"
    value = module.clusters[0].aks_name
  }
}

# Configure Helm provider for second cluster
provider "helm" {
  alias = "cluster2"
  kubernetes {
    host                   = module.clusters[1].host
    client_certificate     = base64decode(module.clusters[1].client_certificate)
    client_key             = base64decode(module.clusters[1].client_key)
    cluster_ca_certificate = base64decode(module.clusters[1].cluster_ca_certificate)
  }
}

# Deploy Robusta and Prometheus to cluster 2
resource "helm_release" "robusta2" {
  provider   = helm.cluster2
  name       = "robusta"
  repository = "https://robusta-charts.storage.googleapis.com"
  chart      = "robusta"

  values = [
    "${file(var.helm_values_path)}"
  ]

  set {
    name  = "clusterName"
    value = module.clusters[1].aks_name
  }
}