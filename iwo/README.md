# Connect Kubernetes Cluster to Intersight

Detailed information can be found in the Cisco Intersight Workload Optimizer Target Configuration Guide:   
https://cdn.intersight.com/components/an-hulk/1.0.9-679/docs/cloud/data/resources/iwo/Cisco_Intersight_Workload_Optimizer_Target_Configuration_Guide.pdf  

## Step 1: run the helm script to install the collector and the device connector  
helm install iwo ./iwo/helm/ -n iwo --create-namespace  

## Step 2: change some settings on the device connector  
Execute the command, where iwo-collector is the namespace you defined for the collector, and my-iwo-k8scollector-57fcb8b874-s5ch8 is the full pod name for your collector:  
kubectl -n iwo-collector port-forward my-iwo-k8s-collector-57fcb8b874-s5ch8 9110  

### Step 2a: Configure the proxy connection from the collector to intersight.com
Don't close the window where you opened the port forwarding. Open another terminal window.  
curl -XPUT http://localhost:9110/HttpProxies -d '{"ProxyType":"Manual", "ProxyHost":"My_Proxy_Server", "ProxyPort":My_Proxy_Port}'  
Replace the values for My_Proxy_Server and My_Proxy_Port with the values for your proxy server.  

### Step 2b: Get the Device ID and Claim Code
curl -s http://localhost:9110/DeviceIdentifiers  
curl -s http://localhost:9110/SecurityTokens  

## Step 3: Use the information from Step 2b to claim the device in Intersight
You can claim the device connector under Cloud Native/Kubernetes  

