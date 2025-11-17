#!/bin/bash

# This script renames existing Azure subscriptions.
# ⚠️ Note: This uses the experimental `az account subscription rename` command,
# which is part of the Azure CLI extensions (requires a recent CLI version).

# Rename the subscription with ID "XXXXXXXXXXXXXXXXXXXXX"
az account subscription rename --subscription-id XXXXXXXXXXXXXXXXXXXXX --name "a-net"

# Rename the subscription with ID "XXXXXXXXXXXXXXXXXXXXX"
az account subscription rename --subscription-id XXXXXXXXXXXXXXXXXXXXX --name "a-app1-prd"

# Rename the subscription with ID "XXXXXXXXXXXXXXXXXXXXX"
az account subscription rename --subscription-id XXXXXXXXXXXXXXXXXXXXX --name "a-iac"

# Rename the subscription with ID "XXXXXXXXXXXXXXXXXXXXX"
az account subscription rename --subscription-id XXXXXXXXXXXXXXXXXXXXX --name "a-management"