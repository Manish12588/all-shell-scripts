#!/bin/bash

read -p "Please provide which cluster you wanted to create "kind", "minukube" " CLUSTER_NAME

if [[ "$CLUSTER_NAME" == "kind"  ]]; then
    
    if command -v kind &>/dev/null; then
        KIND_VERSION=$(kind --version 2>/dev/null)
        echo "kind is already installed!"
        echo "Version: $KIND_VERSION"
    else
        echo "kind not found. Installing..."
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/kind

        # Verify after install
        if command -v kind &>/dev/null; then
            echo "kind installed successfully!"
            echo "Version: $(kind --version)"
        else
            echo "Installation failed. Please install manually."
            exit 1
        fi
    fi
        
elif [ "$CLUSTER_NAME" == "minukube" ]; then
    echo "minikube"
else 
    echo "Please choose one of them 'kind' or 'minikube' "
fi