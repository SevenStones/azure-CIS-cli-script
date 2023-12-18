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
while IFS= read -r sub; do
    echo "Checking subscription: $sub"
    # Set the current subscription
    az account set --subscription "$sub"
    
    # Get all storage accounts in the subscription
    storageAccounts=$(az storage account list --query '[].{Name:name,ResourceGroup:resourceGroup}' -o tsv)
    
    # Check 'Secure Transfer Required' for each storage account
    while IFS=$'\t' read -r name resourceGroup; do
        echo "Storage Account: $name, Resource Group: $resourceGroup"
        secureTransfer=$(az storage account show --name $name --resource-group $resourceGroup --query 'enableHttpsTrafficOnly')
        echo "Secure Transfer Required: $secureTransfer"
    done <<< "$storageAccounts"
done < "$SUBSCRIPTION_FILE"

echo "Done"
