#!/bin/bash
# Ian Tibble - 8th September 2023
#
# Read subscription IDs from a text file in the same directory, named "subscriptions.txt"
# and list the keyvaults. 

while IFS= read -r sub; do
    # Skip empty lines
    if [ -z "$sub" ]; then
        continue
    fi

    echo "Listing RBAC-enabled Key Vaults for subscription: $sub"
    az keyvault list --subscription "$sub" --query "[?properties.enableRbacAuthorization==true].{SubscriptionId:'$sub', Name:name, RBAC:properties.enableRbacAuthorization, AccessPolicies:properties.accessPolicies}" --output table
    
    echo "Listing non-RBAC Key Vaults for subscription: $sub"
    az keyvault list --subscription "$sub" --query "[?properties.enableRbacAuthorization!=true].{SubscriptionId:'$sub', Name:name, RBAC:properties.enableRbacAuthorization, AccessPolicies:properties.accessPolicies}" --output table
done < subscriptions.txt

