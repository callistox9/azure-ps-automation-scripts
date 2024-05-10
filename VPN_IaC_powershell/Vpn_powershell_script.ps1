#Powershell Script to deploy virtual network gateway in azure
#Connect Az Account
Import-Module Az.Resources
Import-Module Az.Network
Connect-AzAccount -UseDeviceAuthentication -SubscriptionId "xxxx-xxxx-xxxx"
#Double check subscription, just to be sure, cause I have messed up multiple times
set-AzContext -Subscription "xxxx-xxxx-xxxx"
#create resource group if does not exist
New-AzResourceGroup -Name TestRG1 -Location EastUS

#Create Virtual Network And Add Subnet, if does not exist
$virtualNetwork = New-AzVirtualNetwork -ResourceGroupName TestRG1 -Location EastUS -Name VNet1 -AddressPrefix 10.1.0.0/16 
Add-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix 10.1.255.0/27 -VirtualNetwork $virtualNetwork | Set-AzVirtualNetwork

#OR get the Virtual network of your requirement and add gatewaySubnet, which is required for Virtual Network Gateway Services.

$vnet = Get-AzVirtualNetwork -ResourceGroupName TestRG1 -Name VNet1
Add-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix 10.1.255.0/27 -VirtualNetwork $vnet | Set-AzVirtualNetwork
#NOTE - The nate of subnet should be exactly the same as it is necessary for VPN to work
