#!/usr/bin/env bash

# Path to the file containing subscription IDs
SUBSCRIPTIONS_FILE="subscriptions.txt"

# Check if the subscription file exists
if [ ! -f "$SUBSCRIPTIONS_FILE" ]; then
    echo "Subscription file not found: $SUBSCRIPTIONS_FILE"
    exit 1
fi

# Iterate over each subscription ID from the file
while read -r subscriptionId; do
    # Set the subscription context
    az account set --subscription "$subscriptionId"

    # Get the name of the current subscription
    subscriptionName=$(az account show --query "name" -o tsv)

    echo "Checking NSG Flow Logs in subscription $subscriptionName ($subscriptionId)"

    # List all network watchers in the subscription
    networkWatchers=$(az network watcher list --query "[].{location:location, name:name}" -o tsv)

    # Iterate over each Network Watcher
    while IFS=$'\t' read -r location nwName; do
        # List all flow logs in the network watcher location
        flowLogs=$(az network watcher flow-log list --location $location --query "[].{name:name, retentionPolicy:retentionPolicy.days}" -o tsv)

        # Iterate over each flow log
        while IFS=$'\t' read -r flowLogName retentionPolicy; do
            echo "Flow Log: $flowLogName (Network Watcher: $nwName, Location: $location) - Retention Period: $retentionPolicy"
        done <<< "$flowLogs"

    done <<< "$networkWatchers"

done < "$SUBSCRIPTIONS_FILE"


