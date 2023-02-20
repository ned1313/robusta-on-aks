# Get connected to your other cluster
RESOURCE_GROUP=YOUR_RESOURCE_GROUP
CLUSTER_NAME=YOUR_CLUSTER_NAME

az login

az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME

# Clone the repo for acme fitness
git clone https://github.com/vmwarecloudadvocacy/acme_fitness_demo.git

# Go into the acme_fitness_demo/kubernetes-manifests directory
cd acme_fitness_demo/kubernetes-manifests

# Deploy the services using the following commands and manifests
kubectl create secret generic cart-redis-pass --from-literal=password=hr567ytfghu76yhgfr56y
kubectl apply -f cart-redis-total.yaml
kubectl apply -f cart-total.yaml
kubectl create secret generic catalog-mongo-pass --from-literal=password=hr567ytfghu76yhgfr56y
kubectl create -f catalog-db-initdb-configmap.yaml
kubectl apply -f catalog-db-total.yaml
kubectl apply -f catalog-total.yaml
kubectl apply -f payment-total.yaml
kubectl create secret generic order-postgres-pass --from-literal=password=hr567ytfghu76yhgfr56y
kubectl apply -f order-db-total.yaml
kubectl apply -f order-total.yaml
kubectl create secret generic users-mongo-pass --from-literal=password=hr567ytfghu76yhgfr56y
kubectl create secret generic users-redis-pass --from-literal=password=hr567ytfghu76yhgfr56y
kubectl create -f users-db-initdb-configmap.yaml
kubectl apply -f users-db-total.yaml
kubectl apply -f users-redis-total.yaml
kubectl apply -f users-total.yaml
kubectl apply -f frontend-total.yaml
kubectl get services -l service=frontend
kubectl apply -f point-of-sales-total.yaml
kubectl get services -l service=pos

# Check on the pods
kubectl get pods

# You may need to add another node to your cluster to handle the load

# Now we'll add some traffic to the cluster
# You'll need python3.6+ installed

cd ../traffic-generator/

# Create virtual environment
python3 -m venv venv

# Activate virtual environment depending on shell
# Ex PowerShell
.\venv\Scripts\activate.ps1

# Install locust and requirements
pip3 install locust
pip3 install -r requirements.txt

# Get where the frontend service is
kubectl get services -l service=frontend

# Run the locust test with the frontend service IP
locust --host=http://<frontend service IP>:80

# Now open a browser and go to http://localhost:8089 and start a test with peak users
# of 100 and a hatch rate of 10, let it run for a few minutes



