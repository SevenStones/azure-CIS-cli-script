# azure-CIS-cli-script
Various BASH cli scripts for Azure CIS Benchmarks 2.0

Note: you have to populate the subscriptions.txt file with lines of subscription IDs. 

1.4, 1.5 – Review Guest Users – script list the Guest users configured in Entra

1.23 – Ensure That No Custom Subscription Administrator Roles Exist

3.1 - Ensure that 'Secure transfer required' is set to 'Enabled' [Storage Accounts]

3.2 - Ensure that ‘Enable Infrastructure Encryption’ for Each Storage Account in Azure Storage is Set to ‘enabled’

3.7 - Ensure that 'Public access level' is disabled for storage accounts with blob containers

3.10 - Ensure Private Endpoints are used to access Storage Accounts

3.11 - Ensure Soft Delete is Enabled for Azure Containers and Blob Storage

3.12 - Ensure Storage for Critical Data are Encrypted with Customer Managed Keys

3.15 - Ensure the "Minimum TLS version" for storage accounts is set to "Version 1.2"

5.1.3 - Ensure the Storage Container Storing the Activity Logs is not Publicly Accessible

5.1.6 - Ensure that Network Security Group Flow logs are captured and sent to Log Analytics

6.5 - Ensure that Network Security Group Flow Log retention period is 'greater than 90 days'

6.7 - Ensure that Public IP addresses are Evaluated on a Periodic Basis (lists the addresses)

7.4 - Ensure that 'Unattached disks' are encrypted with 'Customer Managed Key' (CMK) (lists unattached disks)

8.2 - Ensure that the Expiration Date is set for all Keys in Non-RBAC Key Vaults (usually all key vaults will be RBAC enabled, 
making this control non-applicable. One script lists the RBAC and non-RBAC Key Vaults, then there's an **untested** script
for listing the non-expiring keys)

8.3 - Ensure that the Expiration Date is set for all Secrets in RBAC Key Vaults. The script is untested because of a lack of access
to a test key vault(s).

8.4 - Ensure that the Expiration Date is set for all Secrets in Non-RBAC Key Vaults (usually all key vaults will be RBAC enabled, 
making this control non-applicable. One script lists the RBAC and non-RBAC Key Vaults, then there's an **untested** script
for listing the non-expiring secrets)

10.1 - Ensure that Resource Locks are set for Mission-Critical Azure Resources



5.1.6 needed some work. The 'nsg' parameter was made obsolete. Technically the script will run with a warning if the 'nsg' parameter is used, but anyway I have done as suggested and used the '--location and --name combination' in the az network watcher command instead. 
