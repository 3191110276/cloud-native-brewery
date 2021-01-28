## This helm chart will install AppDynamics Agents
A good explanation of how the appdynamics operator can be configured can be found on the below link :wq
https://github.com/Appdynamics/appdynamics-operator

# Prerequisites
A valid values.yaml needs to be completed

# Installation Process
Use: helm install [releasename] [helmdir] 
After installing the appd helm chart the appdynamics operator will be created and will spin up the 
cluster-agent pod as well as an infraviz pod on each of the nodes.
This process will take a couple of minutes after which the cluster agent will be visible in AppDynamics.
Be patient populating the Clusters Dashboard and inventory may take 15 minutes or so to fully complete.

# Uninstall Process
Use: helm uninstall releasename -n namespace
Couple of minutes after uninstall the pods will be removed.
It will take 15 minutes or so before the AppDynamics system itself will recognize connectivity with the cluster agent is broken.  
