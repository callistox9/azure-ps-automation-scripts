# Organized script to deploy virtual network gateway in azure

# Import required modules
Import-Module Az.Resources
Import-Module Az.Network
$SubscriptionId="xxxx-xxxx-xxxx"
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
$virtualNetwork = New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location -Name $VirtualNetworkName -AddressPrefix $AddressPrefix
Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressPrefix -VirtualNetwork $virtualNetwork | Set-AzVirtualNetwork

# NOTE - The name of subnet should be exactly the same as it is necessary for VPN to work

# PublicIPAddress
$PublicIpAddressName = "VNet1GWIP"
$gwpip = New-AzPublicIpAddress -Name $PublicIpAddressName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Static

# Creating GatewayIp address configuration
$vnet = Get-AzVirtualNetwork -Name $VirtualNetworkName -ResourceGroupName $ResourceGroupName
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $vnet
$GatewayIpConfigName = "gwipconfig1"
$gwipconfig = New-AzVirtualNetworkGatewayIpConfig -Name $GatewayIpConfigName -SubnetId $subnet.Id -PublicIpAddressId $gwpip.Id

# Creating VPN gateway
$VirtualNetworkGatewayName = "VNet1GW"
$Location = "East US"
$GatewayType = "Vpn"
$VpnType = "RouteBased"
$GatewaySku = "VpnGw2"
$VpnGatewayGeneration = "Generation2"
New-AzVirtualNetworkGateway -Name $VirtualNetworkGatewayName -ResourceGroupName $ResourceGroupName -Location $Location -IpConfigurations $gwipconfig -GatewayType $GatewayType -VpnType $VpnType -GatewaySku $GatewaySku -VpnGatewayGeneration $VpnGatewayGeneration

# Deployment of this resource may take 45-50 mins.
