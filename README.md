# IWO-AppDynamics Demonstration Application
The default application simulates the ordering and order fulfilment process for a brewery,
the application can be easily renamed to reflect a different use-case. 

## Provision Script 
The provision script will install seven components through separate helm charts.
Every chart installs several components:
- Appdynamics Components: appd cluster agent, appd db agent, metrics server.
- Traffic Generator: a container that simulates user requests from different regions
- External Payment: a container that simulates an external payment service (ie. credit card, paypal, ...)
- External Production: a container that simulates a production facility/factory
- Intersight Workload Optimizer agent: kubeturbo
- Stealthwatch Agent
- The main application including: payment, fulfilment, order, production, notification, etc...

./provision.sh

## Unprovision
./unprovision.sh