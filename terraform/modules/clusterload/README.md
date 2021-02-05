# IWO Demonstrations for Containers

1. Deploy a POD that has an oversized CPU request. Demonstrates the capability of IWO to downscale on inefficient use of resources.

2. Deploy a POD with a compliance issue. Create a placement rule so that a POD can only be placed on nodes with a specific label. Delete the label on the POD creating a compliance issue
   How to define node affinity is described here: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/
	- Label a node. There is pre-defined gpu-pod.yaml that will match a node that has the label capability=gpu
          kubectl label node <nodename> <key>:<value>
	- Set a nodeSelector on the POD - a deployment that has a nodeselector with key:value capability=gpu is in this directory 
	- Create the deployment with the POD, it wil be placed only on nodes that have a label matching the nodeSelector criteria
	- Remove the label from the node, the POD will remain and is now violating the placement rule.
          kubectl label node <nodename> <key>-
	- Put the label on another node and IWO will recommend to migrate the POD to ensure compliance	

3. Cordon all nodes so that workloads are moved to a single node. Uncordon the nodes and show that the cluster will propose POD moves
	- Drain some of the nodes with.
	  kubectl drain <nodename>
	- Once the nodes have been drained, uncordon them again. The cluster will not automatically rebalance itself. 

4. Oversize a namespace. 
