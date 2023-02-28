# robusta-on-aks

Demo to install Robusta on AKS with Prometheus

The Terraform configuration in this repository will deploy one or more AKS clusters in Azure and deploy both Prometheus and Robusta to the clusters. Since this is for demo purposes, each cluster will have a single small worker node. You should already have the `values.yaml` file ready from the [Robusta getting start guide](https://docs.robusta.dev/master/installation.html). The configuration will require that you specify the path to the values file in the `terraform.tfvars`.

The configuration will deploy two clusters by default. If you want to deploy a single cluster, you can do the following:

* Remove the second helm provider and helm_release resources from `helm.tf`
* Set the `cluster_count` variable to 1 in `terraform.tfvars`

Unfortunately, the Helm provider is cluster specific, so you can't use the same provider for multiple clusters and you can't dynamically generate provider blocks in Terraform. If you want to deploy more than two clusters, you'll need to add additional provider and helm_release resources and change your `cluster_count` variable.

## Prerequisites

You will need the following:

* An Azure subscription
* Azure CLI or other authentication method for Terraform
* Terraform 1.3.0 or later
* Robusta values file generated from the Robusta CLI

## Deploying the clusters

Start by logging into Azure using the CLI:

```bash
az login
az account set -s "SUBSCRIPTION_NAME"
```

Create a copy of the `terraform.tfvars.example` file and name it `terraform.tfvars`. Edit the file and set the `helm_values_path` variable to the path to your Robusta values file. Change the `cluster_count` variable if you want to deploy a single cluster and make the alterations noted earlier.

Then, initialize and run Terraform:

```bash
terraform init
terraform apply
```

When the deployment is complete, the Terraform output will show you the resource group and cluster names. You can use the `az aks get-credentials` command to configure your local kubectl to connect to the clusters.

```bash
az aks get-credentials --resource-group <resource-group-name> --name <cluster-name>
```

## Deploying Test Applications

The following directories contain sample applications that can be deployed to the clusters:

* `crashing_pod` - A simple pod that crashes each time it starts
* `load_test` - A simple php application and load generator
* `acme_fitness` - A twelve-factor, polyglot application and scripts to run locust against it

Depending on which applications you deploy, you may need to scale up the node pools beyond the default of 1. You can do this by editing the `agents_count` local value in `aks.tf` and running `terraform apply` again. I recommed scaling up after application deployment, so you can see the errors come in through Robusta.

## Cleaning up

When you're done with the demo, you can destroy the clusters and all resources with the following command:

```bash
terraform destroy
```

Thanks and have fun!

Ned
