#!/bin/bash
#Ian Tibble - 8th sept 23
# this script wasn't tested for lack of a suitable environment (access to key metadata)

while IFS= read -r sub; do
    # Skip empty lines
    if [ -z "$sub" ]; then
        continue
    fi

    echo "Listing non-RBAC Key Vaults for subscription: $sub"
    non_rbac_vaults=($(az keyvault list --subscription "$sub" --query "[?properties.enableRbacAuthorization!=true].name" --output tsv))

    for vault in "${non_rbac_vaults[@]}"; do
        echo "Checking keys in Key Vault: $vault"

        keys_without_expiry=($(az keyvault key list --vault-name "$vault" --query "[?attributes.exp==null].kid" --output tsv))

        if [ ${#keys_without_expiry[@]} -gt 0 ]; then
            echo "Keys without expiry in Key Vault '$vault':"
            printf '%s\n' "${keys_without_expiry[@]}"
        else
            echo "All keys in Key Vault '$vault' have expiry dates set."
        fi
    done
done < subscriptions.txt

