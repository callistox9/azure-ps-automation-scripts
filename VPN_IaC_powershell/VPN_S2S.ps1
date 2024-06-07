# As there are multiple variables, dot-sourcing to store values for different variables 

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

# NOTE - The name of subnet should be exactly the same as it is necessary for VPN to work

# Creating Local Network Gateway

#The GatewayIPAddress is the IP address of your on-premises VPN device.
#The AddressPrefix is your on-premises address space.

$LocalNetworkGatewayName = "LocalSite1"


$LocalNetworkGatewayAddressPrefix = "244.178.44.111/24"
$OnPremiseAddressSpace = "244.178.44.111/24"

New-AzLocalNetworkGateway -Name $LocalNetworkGatewayName -ResourceGroupName $ResourceGroupName -Location  -GatewayIpAddress $LocalNetworkGatewayAddressPrefix -AddressPrefix $OnPremiseAddressSpace 

#Multiple -AddressPrefixe @(244.178.44.111/24, 244.178.44.111/24)

# PublicIPAddress
$PublicIpAddressName = "VNet1GWIP"
$gwpip = New-AzPublicIpAddress -Name $PublicIpAddressName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Static -Sku Standard

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

#Configuring on-premise VPN device

Get-AzPublicIpAddress -Name $PublicIpAddressName -ResourceGroupName $ResourceGroupName

$gateway1 = Get-AzVirtualNetworkGateway -Name $VirtualNetworkGatewayName -ResourceGroupName $ResourceGroupName
$local = Get-AzLocalNetworkGateway -Name $LocalNetworkGatewayName -ResourceGroupName  $ResourceGroupName

#Create Connection

$gatewayConnectionName = "VNet1toSite1"
$location = "East US"
$connectionType = "IPsec"
$sharedKey = "abc123"

New-AzVirtualNetworkGatewayConnection -Name $gatewayConnectionName -ResourceGroupName $ResourceGroupName -Location $location -VirtualNetworkGateway1 $gateway1 -LocalNetworkGateway2 $local -ConnectionType $connectionType -SharedKey $sharedKey

# Verify the Connection
Get-AzVirtualNetworkGatewayConnection -Name $gatewayConnectionName -ResourceGroupName $ResourceGroupName

<# After the cmdlet has finished, view the values. In the example below, the connection status shows as 'Connected' and you can see ingress and egress bytes.
"connectionStatus": "Connected",
"ingressBytesTransferred": 33509044,
"egressBytesTransferred": 4142431 #>