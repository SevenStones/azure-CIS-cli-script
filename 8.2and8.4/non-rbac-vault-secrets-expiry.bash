#!/bin/bash
#Ian Tibble - 8th sept 23
# this script wasn't tested for lack of a suitable environment (access to key metadata)

while IFS= read -r sub; do
    if [ -z "$sub" ]; then
        continue
    fi

    echo "Listing non-RBAC Key Vaults for subscription: $sub"
    non_rbac_vaults=($(az keyvault list --subscription "$sub" --query "[?properties.enableRbacAuthorization!=true].name" --output tsv))

    for vault in "${non_rbac_vaults[@]}"; do
        echo "Checking secrets in Key Vault: $vault"

        secrets_without_expiry=($(az keyvault secret list --vault-name "$vault" --query "[?attributes.exp==null].id" --output tsv))

        if [ ${#secrets_without_expiry[@]} -gt 0 ]; then
            echo "Secrets without expiry in Key Vault '$vault':"
            printf '%s\n' "${secrets_without_expiry[@]}"
        else
            echo "All secrets in Key Vault '$vault' have expiry dates set."
        fi
    done
done < subscriptions.txt

