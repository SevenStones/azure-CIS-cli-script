subscriptions=("subid1" "subid2" "subid3")

for subscription in "${subscriptions[@]}"; do
    az account set --subscription "$subscription"
    az network public-ip list --query "[].{ipAddress:ipAddress}"
done
