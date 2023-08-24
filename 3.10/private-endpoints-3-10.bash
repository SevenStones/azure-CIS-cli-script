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
        # Get the Private Endpoint Connections
        private_endpoints=$(az storage account show --name $account --resource-group $resourceGroup --query 'privateEndpointConnections[].{id:id, status:privateLinkServiceConnectionState.status}' -o tsv)
        
        if [ -z "$private_endpoints" ]; then
            echo "Subscription: $subscription, Storage Account: $account, Private Endpoint Connections: None"
        else
            while IFS=$'\t' read -r id status; do
                echo "Subscription: $subscription, Storage Account: $account, Endpoint ID: $id, Connection Status: $status"
            done <<< "$private_endpoints"
        fi

    done <<< "$accounts_info"
done < "$SUBSCRIPTIONS_FILE"

