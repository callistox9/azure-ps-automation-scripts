# Organized script to deploy virtual network gateway in azure

# Import required modules
Import-Module Az.Resources
Import-Module Az.Network
$SubscriptionId = "xxxx-xxxx-xxxx"
# Connect to azure account
Connect-AzAccount -UseDeviceAuthentication -SubscriptionId $SubscriptionId
# Verify the subscription
Set-AzContext -Subscription $SubscriptionId

# Create resource group if does not exist
$ResourceGroupName = "TestRG1"
$Location = "EastUS"
New-AzResourceGroup -Name $ResourceGroupName -Location $Location

# Create Virtual Network And Add Subnet, if does not exist
$VirtualNetworkName = "VNet1"
$AddressPrefix = "10.1.0.0/16"
$SubnetName = "GatewaySubnet"
$SubnetAddressPrefix = "10.1.255.0/27"
$SubnetName2 = "Frontend"
$SubnetAddressPrefix2 = "10.1.0.0/24"
$virtualNetwork = New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location -Name $VirtualNetworkName -AddressPrefix $AddressPrefix
Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressPrefix -VirtualNetwork $virtualNetwork | Set-AzVirtualNetwork
Add-AzVirtualNetworkSubnetConfig -Name $SubnetName2 -AddressPrefix $SubnetAddressPrefix2 -VirtualNetwork $virtualNetwork | Set-AzVirtualNetwork

$LocalNetworkGatewayName = "LocalSite1"

#The GatewayIPAddress is the IP address of your on-premises VPN device.
#The AddressPrefix is your on-premises address space.

$LocalNetworkGatewayAddressPrefix = "244.178.44.111/24"
$OnPremiseAddressSpace = "244.178.44.111/24"

New-AzLocalNetworkGateway -Name $LocalNetworkGatewayName -ResourceGroupName $ResourceGroupName -Location  -GatewayIpAddress $LocalNetworkGatewayAddressPrefix -AddressPrefix $OnPremiseAddressSpace 
