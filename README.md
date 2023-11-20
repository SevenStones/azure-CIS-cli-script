# azure-CIS-cli-script
Various BASH cli scripts for Azure CIS Benchmarks 2.0

Note: you have to populate the subscriptions.txt file with lines of subscription IDs. 

1.4, 1.5 – Review Guest Users – script list the Guest users configured in Entra

1.23 – Ensure That No Custom Subscription Administrator Roles Exist

3.10 - Ensure Private Endpoints are used to access Storage Accounts

3.2 - Ensure that ‘Enable Infrastructure Encryption’ for Each Storage Account in Azure Storage is Set to ‘enabled’

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
