#!/bin/bash

read -p "Please provide which cluster you wanted to create "kind", "minukube" " CLUSTER_TYPE
read -p "Please provide the cluster name: " CLUSTER_NAME

if [[ "$CLUSTER_TYPE" == "kind"  ]]; then
    
    echo "Creating kind cluster: $CLUSTER_NAME"
    CREATE_OUTPUT=$(kind create cluster --name "$CLUSTER_NAME" 2>&1)
    EXIT_CODE=$?

    if [[ $EXIT_CODE -eq 0 ]]; then
        echo -e "Cluster '$CLUSTER_NAME' created successfully!\n"
        echo -e "================ CREATED CLUSTER ========================"
        echo "$CREATE_OUTPUT"
        echo -e "========================================================="
    else 
        echo "Failed to creats cluster.!"
        echo "$CREATE_OUTPUT"
        exit 1
    fi      
        
elif [ "$CLUSTER_TYPE" == "minukube" ]; then

    echo "Steps are not implemented yet for minukube.."

else 
    echo "Please choose one of them 'kind' or 'minikube' "
fi