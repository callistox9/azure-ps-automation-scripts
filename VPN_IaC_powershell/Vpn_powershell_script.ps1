#Powershell Script to deploy virtual network gateway in azure
#Connect Az Account
Import-Module Az.Resources
Connect-AzAccount -UseDeviceAuthentication -SubscriptionId "xxxx-xxxx-xxxx"

#create resource group if does not exist
New-AzResourceGroup -Name TestRG1 -Location EastUS

#Create Virtual Network And Add Subnet
$virtualNetwork = New-AzVirtualNetwork -ResourceGroupName TestRG1 -Location EastUS -Name VNet1 -AddressPrefix 10.1.0.0/16
Add-AzVirtualNetworkSubnetConfig -Name Frontend -AddressPrefix 10.1.0.0/24 -VirtualNetwork $virtualNetwork
$virtualNetwork | Set-AzVirtualNetwork


$vnet = Get-AzVirtualNetwork -ResourceGroupName TestRG1 -Name VNet1
Add-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix 10.1.255.0/27 -VirtualNetwork $vnet
$vnet | Set-AzVirtualNetwork