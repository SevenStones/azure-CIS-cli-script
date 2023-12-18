#!/usr/bin/env bash
# Path to the text file containing subscription IDs
SUBSCRIPTIONS_FILE="subscriptions.txt"

while read -r subscription; do
    # Skip empty lines
    [ -z "$subscription" ] && continue

    # Set the active subscription
    az account set --subscription "$subscription"

    # Fetch the name of the current subscription
    subscription_name=$(az account show --subscription "$subscription" --query "name" -o tsv)

    # Fetch all storage accounts in the subscription
    accounts_info=$(az storage account list --query "[].{name:name, resourceGroup:resourceGroup}" -o tsv)

    echo "Checking Soft Delete Status for Subscription: $subscription_name ($subscription)"

    while IFS=$'\t' read -r account resourceGroup; do
        # Check the Soft Delete property for Blob Service
        soft_delete_status=$(az storage account blob-service-properties show --account-name $account --resource-group $resourceGroup --query 'deleteRetentionPolicy.enabled' -o tsv)

        # Output the status
        echo "Subscription Name: $subscription_name, Subscription ID: $subscription, Storage Account: $account, Soft Delete Status: $soft_delete_status"

    done <<< "$accounts_info"

done < "$SUBSCRIPTIONS_FILE"
