#!/bin/bash

SUBSCRIPTION_FILE="subscriptions.txt"

while read -r subscription_id; do
    # Skip empty lines
    if [ -z "$subscription_id" ]; then
        continue
    fi

    az account set --subscription "$subscription_id"

    subscription_name=$(az account show --subscription "$subscription_id" --query "name" -o tsv)
    echo "Checking Subscription: $subscription_name"

    resource_groups=$(az group list --query "[].name" -o tsv)

    for rg in $resource_groups; do
        locks=$(az lock list --resource-group "$rg" --query "[].{LockName:name, LockType:level}" -o tsv)

        if [ ! -z "$locks" ]; then
            echo "Resource Group: $rg"
            echo "$locks"
            echo "---------------------------------------------------------"
        fi
    done

    echo "Completed checking subscription: $subscription_name"
    echo "========================================================="

done < "$SUBSCRIPTION_FILE"

