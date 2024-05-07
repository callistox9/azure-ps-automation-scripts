#powershell Script to deploy virtual network gateway in azure
New-AzResourceGroup -Name TestRG1 -Location EastUS

$virtualNetwork = New-AzVirtualNetwork -ResourceGroupName TestRG1 -Location EastUS -Name VNet1 -AddressPrefix 10.1.0.0/16

$subnetConfig = Add-AzVirtualNetworkSubnetConfig -Name Frontend -AddressPrefix 10.1.0.0/24 -VirtualNetwork $virtualNetwork

$subnetConfig = Add-AzVirtualNetworkSubnetConfig -Name Frontend -AddressPrefix 10.1.0.0/24 -VirtualNetwork $virtualNetwork

$virtualNetwork | Set-AzVirtualNetwork

$vnet = Get-AzVirtualNetwork -ResourceGroupName TestRG1 -Name VNet1