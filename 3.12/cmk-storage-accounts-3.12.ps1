# Ensure Azure CLI is installed and logged in

# Path to the text file containing subscription IDs
$subscriptionIdsFile = "subscriptions.txt"
# Ensure Azure CLI is installed and logged in

# Read the subscription IDs from the file
$subscriptionIds = Get-Content $subscriptionIdsFile

# Iterate over each subscription ID
foreach ($subscriptionId in $subscriptionIds) {
    # Set the subscription context
    az account set --subscription $subscriptionId

    # Get the subscription name
    $subscriptionName = az account show --subscription $subscriptionId --query "name" | ConvertFrom-Json

    # Get all storage accounts in the subscription
    $storageAccounts = az storage account list --query "[].{name:name, resourceGroup:resourceGroup}" | ConvertFrom-Json

    # Iterate over each storage account
    foreach ($storageAccount in $storageAccounts) {
        # Get storage account properties
        $storageAccountProperties = az storage account show --name $storageAccount.name --resource-group $storageAccount.resourceGroup --query "encryption.keySource" | ConvertFrom-Json

        # Check if the storage account is encrypted with customer-managed keys
        if ($storageAccountProperties -eq "Microsoft.Keyvault") {
            Write-Host "$($storageAccount.name) in Subscription: $subscriptionName ($subscriptionId) is encrypted with customer-managed keys."
        } else {
            Write-Host "$($storageAccount.name) in Subscription: $subscriptionName ($subscriptionId) is NOT encrypted with customer-managed keys."
        }
    }
}
