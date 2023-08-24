#!/bin/bash

# Path to the text file containing subscription IDs
SUBSCRIPTIONS_FILE="subscriptions.txt"

while read -r subscription; do
    # Skip empty lines
    [ -z "$subscription" ] && continue

    # Set the active subscription
    az account set --subscription "$subscription"

    # Fetch all storage accounts in the subscription
    accounts_info=$(az storage account list --query "[].{name:name, resourceGroup:resourceGroup}" -o tsv)

    while IFS=$'\t' read -r account resourceGroup; do
        # Get the "Infrastructure encryption" status
        infra_encryption=$(az storage account show --name $account --resource-group $resourceGroup --query 'encryption.requireInfrastructureEncryption' -o tsv)
        
        echo "Subscription: $subscription, Storage Account: $account, Infrastructure Encryption: $infra_encryption"
    done <<< "$accounts_info"
done < "$SUBSCRIPTIONS_FILE"

