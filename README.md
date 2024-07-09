# CloudAutomate

CloudAutomate is a collection of PowerShell scripts designed to streamline and automate various tasks within Microsoft Azure. This repository aims to simplify cloud management by providing ready-to-use scripts that enhance efficiency and reduce manual intervention.

# Table of Contents

- [CloudAutomate](#cloudautomate)
- [auto_start_stop_runbook_script](#auto_start_stop_runbook_script)
  - [Key Features](#key-features)
  - [Run Script](#run-the-script)
- [marketplace_VM](#marketplace_vm)
  - [check_marketplace_vm](#check_marketplace_vmps1)
  - [create_marketplace_vm](#create_marketplace_vmsh)
- [RBAC](#rbac)
  - [Automation_Script](#automation_rbac_csv_scriptps1)
- [VPN](#vpn_powershell_scriptps1)
  - [VPN_Deployment](#vpn_iac_powershell)
- [Legacy](#legacy)

# auto_start_stop_runbook_script

This PowerShell script automates stopping and starting Azure Virtual Machines (VMs) based on specified tags.This a runbook script used in automation account.The script is availble in Azure,However, the charges are hefty. Therefore, i have made this script. It requires Azure PowerShell modules (Az.Accounts, Az.Compute) and ensures proper execution with elevated privileges.

#### Key Features

- Tag-Based Filtering: Stops and starts VMs with a specified tag (Project) and tag value (Test).
- Error Handling: Provides clear error messages for any failures.
- Delayed Restart: Includes a 180-second delay between stopping and starting the VMs.

###### Run the script

`.\Auto Stop-Start VM.ps1`

# marketPlace_vm

This PowerShell script verifies the existence of a specified Azure Marketplace VM image in a given region and subscription, and then accepts its terms and conditions to facilitate deployment. It first checks if the Sophos VM image with specified parameters exists in the "eastus" region. If the VM image is available, it proceeds to accept the terms and conditions for a Fortinet VM, ensuring compliance and readiness for deployment. This script is designed for test purposes, and users should modify the parameters to match their specific Marketplace VM requirements.

#### check_marketPlace_VM.ps1

**Check VM Existence:**
`Get-AzVMImage -Location "eastus" -PublisherName "sophos" -Offer "sophos-xg" -Skus "Linux (sfos 19)"`

**Accept Marketplace Terms:**
`Get-AzMarketplaceTerms -Publisher "fortinet" -Product "fortinet_fortigate-vm_v5" -Name "fortinet_fg-vm_payg_20190624" -OfferType 'fortinet_fortigate-vm_v5' | Set-AzMarketplaceTerms -Accept`
**Note:** _Customize the parameters for your specific Marketplace VM._

#### create_marketPlace_VM.sh

Create the marketplace VM,(third-party os-VMs, not provided by Microsoft)
Deploys a Marketplace VM named "GasdayFTP" with specified configurations in the "GASDAYFTP" resource group.
**Note:** Customize the parameters to match your specific Azure environment and VM requirements.

# RBAC

This PowerShell script automates the assignment of Azure **Role-Based Access Control** **(RBAC)** roles using Azure PowerShell (Az.Resources module). It begins by connecting to Azure using device authentication and specifying a target subscription ID. The script imports role assignments data from a **CSV** file _(role-assignments-2024-03-14.csv)_ for processing. Within a loop, it iterates through each row in the CSV, replacing the source subscription ID (sourceSubId) with the destination subscription ID (destSubId) in the scope field. It also modifies the RoleDefinitionId by extracting the last 32 characters. For each row, it checks if RoleDefinitionId is defined and creates a new RBAC assignment using **New-AzRoleAssignment**. If RoleDefinitionId is null or empty, it logs a warning and skips that assignment, displaying relevant details such as SignInName and RoleDefinitionName. This script provides a structured approach to managing RBAC assignments across Azure subscriptions.

#### $replace_scope_sourceSubId_with_desSubId.ps1

This Script replaces source subscription id with destination subscription id in the **CSV** download from **IAM** in azure subscription

#### add_column_csv_automation_script.ps1

This Script adds a new column **RowNo** to the **CSV** for debugging and error finding purposes

#### Automation_RBAC_CSV_Script.ps1

**_This is the main deployment script that is used for RBAC assignment_**
Refer to this Readme.md for documentation.
[Automation_RBAC.md](./Rbac\Automation_RBAC.md)

# VPN_IaC_powershell

This script automates the deployment of a Virtual Network Gateway in Azure. It starts by importing the necessary Azure modules and defining variables such as subscription ID, resource group, location, virtual network, subnet, public IP address, and gateway configurations. The script connects to your Azure account, verifies the subscription, and checks for the existence of the specified resource group, virtual network, subnet, and public IP address. If they do not exist, it creates them. Finally, it configures the gateway IP address and deploys the Virtual Network Gateway. Note that the subnet name for the VPN gateway must be exactly "GatewaySubnet," and the deployment may take 45-50 minutes.

#### Vpn_powershell_script.ps1

[Vpn_deployment](./VPN_IaC_powershell\Vpn_powershell_script.ps1)

#### VPN_S2S.ps1

[VPN_S2S.ps1](./VPN_IaC_powershell/VPN_S2S.ps1)
