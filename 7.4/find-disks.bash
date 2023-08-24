# Get all the disks in the subscription
resourceGroup="firewall"

disks=$(az disk list --resource-group $resourceGroup --query "[?managedBy==null].{Name:name}" -o tsv)

# Print them out
if [ -z "$disks" ]; then
  echo "No unattached disks found."
else
  echo "Unattached disks found:"
  echo "$disks"
fi

