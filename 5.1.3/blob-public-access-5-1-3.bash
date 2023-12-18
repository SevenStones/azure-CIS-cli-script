#!/usr/bin/env bash

SUBSCRIPTIONS_FILE="subscriptions.txt"

if [ ! -f "$SUBSCRIPTIONS_FILE" ]; then
    echo "Subscription file not found: $SUBSCRIPTIONS_FILE"
    exit 1
fi

while read -r subscriptionId; do

    az account set --subscription "$subscriptionId"

    subscriptionName=$(az account show --query "name" -o tsv)

    accounts=$(az storage account list --query "[].name" -o tsv)

    for account in $accounts; do

        allowBlobPublicAccess=$(az storage account show --name $account --query "allowBlobPublicAccess")

        if [ "$allowBlobPublicAccess" == "false" ]; then
            echo "Public access is disabled for $account in subscription $subscriptionName ($subscriptionId)"
        else
            echo "Public access is enabled for $account in subscription $subscriptionName ($subscriptionId)"
        fi
    done
done < "$SUBSCRIPTIONS_FILE"
