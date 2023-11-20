# CIS benchmarks for Azure 2.0, refs 1.4 and 1.5 - list the guest users to aid in decision making/review on the list
# Ian Tibble - 20th November 2023 - ian.tibble@seven-stones.biz
az ad user list --filter "userType eq 'Guest'" --query "[].{name:displayName, userPrincipalName:userPrincipalName}" -o table
