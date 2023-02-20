output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "cluster_names" {
  value = module.clusters[*].aks_name
}