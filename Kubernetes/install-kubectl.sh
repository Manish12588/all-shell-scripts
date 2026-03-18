#!/bin/bash

read -p "On Which Machine You Wanted To Install: " OS_NAME

if [ "$OS_NAME" == "Windows"  ]; then
    echo -e "\nInstallation Start on Windows..."

        
elif [ "$OS_NAME" == "MacOs" ]; then
    echo -e "\nInstallation Start on MacOs..."


elif [ "$OS_NAME" == "Linux" ]; then

    KUBECTL_VERSION=$(kubectl version --client 2>/dev/null)
    if command -v kubectl &>/dev/null; then
    echo "✅ kubectl is installed!"
    echo "$KUBECTL_VERSION"
    else
    echo "❌ kubectl not found. Starting installation..."
    
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    
    #Installation Verifications
     if command -v kubectl &>/dev/null; then
        echo "✅ kubectl installed successfully!"
        kubectl version --client
     else
        echo "❌ Installation failed. Please install manually."
        exit 1
      fi    
    fi    

else 
    echo "Please paas one of them "Windows", "MacOs" or "Linux"."
fi