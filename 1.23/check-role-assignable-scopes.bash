#!/bin/bash
# CIS benchmarks for Azure 2.0 ref 1.23 "Ensure That No Custom Subscription Administrator Roles Exist"

# Run the Azure CLI command
az role definition list --custom-role-only True 2>&1
