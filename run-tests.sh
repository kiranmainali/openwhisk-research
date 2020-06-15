# Execute the tests, should be executed in the OpenWhisk source code folder
cd ./openwhisk
CONNECTIONS="1" PAUSE_BETWEEN_INVOKES="20" OPENWHISK_HOST="https://$(minikube ip):31001" API_KEY="23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP" MEAN_RESPONSE_TIME="100" ./gradlew gatlingRun-org.apache.openwhisk.LatencySimulation || exit 1

# Get the results from Kubernetes
kubectl describe node --namespace=openwhisk

# Get the results from docker
eval $(minikube docker-env)
docker stats --no-stream
