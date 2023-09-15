#!/bin/bash
# Ian Tibble - 15th September 2023
# ** this script is untested because i couldn't get access to the secrets metadata **
# 
# purpose: for testing of compliance with CIS Benchmark point 8.3; 
# "Ensure that the Expiration Date is set for all Secrets in RBAC Key Vaults"
# 
# usage: check-secrets-expiry.bash <path to subscriptions file>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <path-to-subscription-ids-file>"
  exit 1
fi

FILE=$1

if ! command -v az &> /dev/null; then
  echo "Azure CLI (az) not found. Please install it first."
  exit 1
fi

while read -r subscription_id; do
  echo "Checking subscription: $subscription_id"
  
  az account set --subscription "$subscription_id"
  
  keyvaults=$(az keyvault list --query '[].name' -o tsv)

  for kv in $keyvaults; do
    echo "Checking keyvault: $kv"

    secrets=$(az keyvault secret list --vault-name "$kv" --query '[].id' -o tsv)

    for secret in $secrets; do
      secret_name=$(basename "$secret")
      expiry_date=$(az keyvault secret show --vault-name "$kv" --name "$secret_name" --query 'attributes.exp' -o tsv)

      if [[ "$expiry_date" == "null" ]]; then
        echo "Secret $secret_name in $kv doesn't have an expiry date set"
      else
        echo "Secret $secret_name in $kv has expiry date set to $expiry_date"
      fi
    done
  done
done < "$FILE"

