if [ -z ${LEAN_OPENWHISK+x} ]; then 
  echo "ERROR: The LEAN_OPENWHISK environment variable is required"; 
  exit 1;
else 
  echo "Deploying with LEAN flag set to $LEAN_OPENWHISK";
fi

# Stop and delete any previous minikube instance,
# otherwise it won't honor the resource requirements
# we specify later.
minikube stop || (echo "Warning: Failed stopping cluster" && true)
minikube delete || (echo "Warning: Failed deleting cluster" && true)

# Create a new minikube cluster with the desired amount of resources
minikube start --memory='4000mb' --cpus=4

# Label all nodes
kubectl label nodes --all openwhisk-role=invoker

# Create the openwhisk namespace
kubectl create namespace openwhisk
kubens openwhisk

# Deploy openwhisk to the cluster
helm install owdev openwhisk-deploy-kube/helm/openwhisk --namespace=openwhisk -f openwhisk.yaml --set whisk.ingress.apiHostName=$(minikube ip) --set controller.lean=$LEAN_OPENWHISK

# Or to delete the deployment
# helm delete owdev
