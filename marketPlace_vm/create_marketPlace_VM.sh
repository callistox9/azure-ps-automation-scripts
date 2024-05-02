# CLI/Bash

# Shows and sets subscription in which the VM is to be created.

az account show
az account set --subscription 5ac9fd75-6b88-400c-a601-d54ff61defef # This Subscription Id is some Random Value
 
# Create Markeplace VM at Desination Subscription (CLI).

az vm create --resource-group "GASDAYFTP" --name "GasdayFTP" --nics "gasdayftp544" --size "Standard_B4ms" --os-type "Windows" --attach-os-disk "GasdayFTP_OsDisk_1_64c077050aae49e4a6d3d6cd8bf7a7af" --plan-name "sftp-2016" --plan-publisher "cloud-infrastructure-services" --plan-product "sftp-2016"

# After this command is executed, marketplace vm of the given parameters for the flag value is created.