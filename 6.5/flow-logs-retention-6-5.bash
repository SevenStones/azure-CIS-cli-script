#!/bin/bash

# File containing subscriptions
SUBSCRIPTION_FILE="subscriptions.txt"

# Ensure the file exists
if [[ ! -f "$SUBSCRIPTION_FILE" ]]; then
    echo "Error: $SUBSCRIPTION_FILE not found."
    exit 1
fi

# Loop through each subscription from the file
while read -r subscription || [[ -n "$subscription" ]]; do
    echo "Checking subscription: $subscription"
    
    # Set the subscription context
    az account set --subscription "$subscription"

    # Get all the Network Watchers in the current subscription
    network_watchers=$(az network watcher list --query "[].{Name: name, Location: location}" -o tsv)

    # Check each Network Watcher for NSG flow logs
    while IFS=$'\t' read -r watcher region; do
        nsg_flow_logs=$(az network watcher flow-log list --location "$region" --query "[].{Name:name, Retention:retentionPolicy.days}" -o tsv)

        # Print out the NSG flow log retention details
        if [ -z "$nsg_flow_logs" ]; then
            echo "- No NSG flow logs found for Network Watcher: $watcher in region: $region"
        else
            echo "$nsg_flow_logs" | while read line
            do
                echo "- Network Watcher: $watcher (Region: $region) - $line"
            done
        fi
    done <<< "$network_watchers"
done < "$SUBSCRIPTION_FILE"

