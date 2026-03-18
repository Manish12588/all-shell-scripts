#!/bin/bash

AVAILABLE_CLUSTERS=$(kind get clusters 2>/dev/null)
echo -e "Available Cluster Name:\n======================""\n$AVAILABLE_CLUSTERS\n"

read -p "Which Cluster you want to delete: " CLUSTER_NAME

