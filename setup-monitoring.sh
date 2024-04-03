#!/bin/bash

# Step 1: Add the stable repository which contains the Helm charts for Prometheus and Grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Step 2: Check if the 'monitoring' namespace exists and create it if not
if kubectl get namespace monitoring; then
    echo "Namespace 'monitoring' already exists"
else
    echo "Namespace 'monitoring' does not exist. Creating..."
    kubectl create namespace monitoring
fi

# Step 3: Install Prometheus using the Helm chart
helm install prometheus prometheus-community/prometheus \
  --namespace monitoring \
  --set alertmanager.persistentVolume.storageClass="gp2" \
  --set server.persistentVolume.storageClass="gp2"

# Check if Prometheus installed successfully
if [ $? -eq 0 ]; then
    echo "Prometheus installed successfully."
else
    echo "Prometheus installation failed."
    exit 1
fi

# Step 4: Install Grafana using the Helm chart
helm install grafana grafana/grafana \
  --namespace monitoring \
  --set persistence.storageClassName="gp2" \
  --set adminPassword='EKS!sAWSome' \
  --set datasources."datasources\.yaml".apiVersion=1 \
  --set datasources."datasources\.yaml".datasources[0].name=Prometheus \
  --set datasources."datasources\.yaml".datasources[0].type=prometheus \
  --set datasources."datasources\.yaml".datasources[0].url=http://prometheus-server.monitoring.svc.cluster.local \
  --set datasources."datasources\.yaml".datasources[0].access=proxy \
  --set datasources."datasources\.yaml".datasources[0].isDefault=true

# Check if Grafana installed successfully
if [ $? -eq 0 ]; then
    echo "Grafana installed successfully."
else
    echo "Grafana installation failed."
    exit 1
fi

# Step 5: Get Grafana password
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# Step 6: Port forward the Grafana service, can access it from local machine
kubectl port-forward --namespace monitoring service/grafana 3000:80
