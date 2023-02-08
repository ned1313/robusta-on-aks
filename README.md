# robusta-on-aks

Demo to install Robusta on AKS with Prometheus

The Terraform configuration in this repository will deploy one or more AKS clusters in Azure and deploy both Prometheus and Robusta to the clusters. Since this is for demo purposes, each cluster will have a single small worker node. You should already have the `values.yaml` file ready from the Robusta getting start guide. The configuration will require that you specify the path to the file in the `terraform.tfvars`.

The configuration will deploy two cluster by default. If you want to deploy more clusters, you will need to add another `helm` provider configuration with a unique alias, and another `helm_release` block for the additional cluster using the new provider alias. Unfortunately, the Helm provider is cluster specific, so you can't use the same provider for multiple clusters and you can't dynamically generate provider blocks in Terraform.

