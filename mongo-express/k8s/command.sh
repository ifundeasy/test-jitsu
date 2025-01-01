#!/bin/bash

# Mongo Express Kubernetes Management Script
# Usage: ./k8s.sh [start|stop|uninstall|reload]

# Variables
NAMESPACE="default"  # Ubah jika Mongo Express berada di namespace lain
DEPLOYMENT_NAME="mongo-express"
CONFIGMAP_NAME="mongo-express-config"
SERVICE_NAME="mongo-express"

# Function to start Mongo Express
start() {
  echo "Starting Mongo Express..."

  # Apply ConfigMap
  kubectl apply -f configmap.yaml
  echo "ConfigMap applied."

  # Apply Deployment
  kubectl apply -f deployment.yaml
  echo "Deployment applied."

  # Apply Service
  kubectl apply -f service.yaml
  echo "Service applied."

  echo "Mongo Express started successfully!"
}

# Function to stop Mongo Express
stop() {
  echo "Stopping Mongo Express..."

  # Scale down the deployment to zero replicas
  kubectl scale deployment $DEPLOYMENT_NAME --replicas=0 -n $NAMESPACE
  if [ $? -eq 0 ]; then
    echo "Mongo Express stopped successfully."
  else
    echo "Failed to stop Mongo Express."
  fi
}

# Function to uninstall Mongo Express
uninstall() {
  echo "Uninstalling Mongo Express..."

  # Delete the deployment
  kubectl delete deployment $DEPLOYMENT_NAME -n $NAMESPACE
  echo "Deployment deleted."

  # Delete the service
  kubectl delete service $SERVICE_NAME -n $NAMESPACE
  echo "Service deleted."

  # Delete the configmap
  kubectl delete configmap $CONFIGMAP_NAME -n $NAMESPACE
  echo "ConfigMap deleted."

  echo "Mongo Express uninstalled successfully!"
}

# Function to reload ConfigMap or Deployment
reload() {
  echo "Reloading Mongo Express configuration..."

  # Reapply ConfigMap
  kubectl apply -f configmap.yaml
  echo "ConfigMap reapplied."

  # Restart the deployment to pick up the new ConfigMap
  kubectl rollout restart deployment $DEPLOYMENT_NAME -n $NAMESPACE
  if [ $? -eq 0 ]; then
    echo "Deployment restarted successfully."
  else
    echo "Failed to restart the deployment."
  fi
}

# Main logic
case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  uninstall)
    uninstall
    ;;
  reload)
    reload
    ;;
  *)
    echo "Usage: $0 [start|stop|uninstall|reload]"
    exit 1
    ;;
esac
