#!/usr/bin/env bash

# File containing subscription IDs
SUBSCRIPTION_FILE="subscriptions.txt"

# Login to Azure (uncomment the next line if you need to login interactively)
# az login

# Check if the subscription file exists
if [ ! -f "$SUBSCRIPTION_FILE" ]; then
    echo "Subscription file not found: $SUBSCRIPTION_FILE"
    exit 1
fi

# Read each subscription ID from the file
while IFS= read -r sub || [ -n "$sub" ]; do
    # Set the current subscription
    az account set --subscription "$sub"
    
    # Get the subscription name
    subName=$(az account show --subscription "$sub" --query 'name' -o tsv)
    echo "Checking subscription: $subName ($sub)"

    # Get all storage accounts in the subscription
    storageAccounts=$(az storage account list --query '[].{Name:name,ResourceGroup:resourceGroup}' -o tsv)
    
    # Check Infrastructure Encryption for each storage account
    while IFS=$'\t' read -r name resourceGroup; do
        echo "Storage Account: $name, Resource Group: $resourceGroup"
        infraEncryption=$(az storage account show --name $name --resource-group $resourceGroup --query 'encryption.requireInfrastructureEncryption' -o tsv)
        echo "Infrastructure Encryption Enabled: $infraEncryption"
    done <<< "$storageAccounts"
done < "$SUBSCRIPTION_FILE"

echo "Done"
