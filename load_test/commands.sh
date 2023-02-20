# Get connected to one of the clusters
RESOURCE_GROUP=YOUR_RESOURCE_GROUP
CLUSTER_NAME=YOUR_CLUSTER_NAME

az login

az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME

# Credit to https://www.techtarget.com/searchitoperations/tutorial/Kubernetes-performance-testing-tutorial-Load-test-a-cluster
# Create a simple PHP application
kubectl create namespace php
kubectl apply -n php -f https://k8s.io/examples/application/php-apache.yaml

kubectl autoscale deployment php-apache --cpu-percent=80 --min=1 --max=4 -n php

kubectl apply -n php -f .\infinite-calls.yaml

kubectl get hpa -n php

# Bump to 4 replicas
kubectl scale deployment/infinite-calls --replicas=4 -n php

# Check on the hpa
kubectl get hpa -n php

# Bump to 8 replicas
kubectl scale deployment/infinite-calls --replicas=8 -n php

# Check on the hpa
kubectl get hpa -n php

# Bump to 16 replicas
kubectl scale deployment/infinite-calls --replicas=16 -n php

# Check on the hpa
kubectl get hpa -n php

# Has the php app crashed?
kubectl port-forward svc/php-apache 80:80 -n php

# Keep scaling till it crashes, I maxed out at 256 replicas
kubectl scale deployment/infinite-calls --replicas=32 -n php

# Also check to see if the new pods are being created
kubectl get pods -n php