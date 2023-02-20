# Create a crashing pod on your currently selected cluster
kubectl apply -f https://gist.githubusercontent.com/robusta-lab/283609047306dc1f05cf59806ade30b6/raw

# Make sure the pod isn't running
kubectl get deployment.apps/crashpod

# Check the logs
kubectl logs deployment.apps/crashpod