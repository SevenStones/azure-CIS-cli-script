#!/usr/bin/env bash

# File containing the list of subscription IDs
SUBSCRIPTIONS_FILE="subscriptions.txt"

# Loop through each subscription ID
while IFS= read -r subscriptionId; do
    # Get subscription name
    subscriptionName=$(az account show --subscription "$subscriptionId" --query "name" -o tsv)

    echo "Checking subscription: $subscriptionName (ID: $subscriptionId)"

    # Set the current subscription
    az account set --subscription "$subscriptionId"

    # Get all storage accounts in the subscription along with their resource group
    storageAccounts=$(az storage account list --query "[].{name:name, group:resourceGroup}" -o tsv)

    while IFS=$'\t' read -r account group; do
        echo "Checking storage account: $account in resource group: $group"

        # Get the networkRuleSet and publicNetworkAccess properties of the storage account
        properties=$(az storage account show --name "$account" --resource-group "$group" --query "{networkRuleSet:networkRuleSet, publicNetworkAccess:publicNetworkAccess}" -o json)
        
        echo "Properties for $account:"
        echo "$properties"
    done <<< "$storageAccounts"
done < "$SUBSCRIPTIONS_FILE"

