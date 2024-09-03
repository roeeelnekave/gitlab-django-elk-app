#!/bin/bash

# Configuration
LOG_DIR="/Users/roeeelnekave/kubernetes-logs"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Function to fetch logs for a deployment
fetch_logs() {
    local deployment=$1
    local label=$2
    local pod_name=$(kubectl get pods -l "app=$label" -o jsonpath='{.items[0].metadata.name}')

    if [ -z "$pod_name" ]; then
        echo "No pod found for deployment: $deployment"
        return 1
    fi

    echo "Fetching logs for $deployment (pod: $pod_name)"
    kubectl logs "$pod_name" > "$LOG_DIR/${deployment}_$TIMESTAMP.log"
}

# Infinite loop to run the script every 30 seconds
while true; do
    # Fetch logs for django-deployment
    fetch_logs "django-deployment" "django"

    # Fetch logs for postgres-deployment
    fetch_logs "postgres-deployment" "postgres"

    # Wait for 30 seconds
    sleep 30
done