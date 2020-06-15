# Lean OpenWhisk Memory Comparison Test Suite

## Table of Contents
+ [About](#about)
+ [Getting Started](#getting_started)
+ [Usage](#usage)

## About<a name = "about"></a>
These scripts setup OpenWhisk in a local single node Kubernetes cluster using Minikube. Afterwards, a minimal test set is ran against this cluster and various statistics on resource usage are displayed.

## Getting Started<a name = "getting_started"></a>
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

This guide is written and tested for MacOS, other OSes are probably able to follow along, although it is likely that some commands need to be adapted to their local alternatives.

### Prerequisites

First, checkout the repository. It is important that also the submodules are  checked out.
```
git checkout https://github.com/Addono/lean-openwhisk-memory-testing.git --recurse-submodules
```

Then, we need to install Minikube.
```bash
brew install minikube
```

### Installing

A script is included to provision Minikube with OpenWhisk, here you will also need to specify whether or not a lean version of OpenWhisk should be deployed.

*Warning: This will destory any previously initialized Minikube environment.*

```bash
❯ LEAN_OPENWHISK=true sh k8s-openwhisk-setup.sh
Deploying with LEAN flag set to true
✋  Stopping "minikube" in hyperkit ...
🛑  "minikube" stopped.
🔥  Deleting "minikube" in hyperkit ...
💔  The "minikube" cluster has been deleted.
🔥  Successfully deleted profile "minikube"
😄  minikube v1.6.2 on Darwin 10.15.1
✨  Selecting 'hyperkit' driver from user configuration (alternates: [virtualbox])
🔥  Creating hyperkit VM (CPUs=4, Memory=4000MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.17.0 on Docker '19.03.5' ...
🚜  Pulling images ...
🚀  Launching Kubernetes ...
⌛  Waiting for cluster to come online ...
🏄  Done! kubectl is now configured to use "minikube"
node/minikube labeled
namespace/openwhisk created
Context "minikube" modified.
Active namespace is "openwhisk".
NAME: owdev
LAST DEPLOYED: Sun Dec 22 14:45:07 2019
NAMESPACE: openwhisk
STATUS: deployed
REVISION: 1
NOTES:
Apache OpenWhisk
Copyright 2016-2018 The Apache Software Foundation

This product includes software developed at
The Apache Software Foundation (http://www.apache.org/).

To configure your wsk cli to connect to it, set the apihost property
using the command below:

  $ wsk property set --apihost 192.168.64.12:31001

Your release is named owdev.

To learn more about the release, try:

  $ helm status owdev [--tls]
  $ helm get owdev [--tls]

Once the 'owdev-install-packages' Pod is in the Completed state, your OpenWhisk deployment is ready to be used.

Once the deployment is ready, you can verify it using:

  $ helm test owdev [--tls] --cleanup
```

If at any point the installation fails, then you can rerun it to reinitialize the complete environment.

Observe the status of the pods and wait until the `owdev-install-packages` pod is ready. You can follow its progress live by running the following command:
```bash
kubectl get $(kubectl get pods -o name --namespace=openwhisk | grep install-packages) --namespace=openwhisk -w
```

The installation is completed when the status of the pod changes to completed.

## Usage<a name = "usage"></a>

After the environment is setup as specified in [Getting Started](#getting_started), then we are ready to run the tests.
```bash
sh run-tests.sh
```

Now, there are three results.
 * **Gatling Latency Test**: At the end of the gatling report, the local directory is displayed where the Gatling test results can be retrieved. This result is mostly useful for determining whether or not the cluster was functional.
 *  **Kubernetes node status**: After the Gatling tests, the output will show the results of `kubectl describe node`, showing the status of the node, including the pods and their allocated resources.
 *  **Docker status**: Lastly, statistics on all running Docker containers is posted by running `docker stats --no-stream`. Most notably, this shows the amount of consumed memory for every container running on the system in all namespaces. Hence, you will also see Kubernetes related services, like its DNS service and main controller, in addition to the ones for OpenWhisk.



### Docker stats

The dumped docker stats can be parsed with the included scripts to relevant data in CSV format.

```bash
cat docker_stats | python parse-docker-stats.py > docker_stats.csv
```