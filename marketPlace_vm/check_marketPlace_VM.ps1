# All the parameters to the flags are for test purpose. User needs to check the export template JSON of the specific marketplace VM of his need.
# The below command checks whether the specific marketplace VM exists in the Destination Subscription or not.

Get-AzVMImage -Location "eastus" -PublisherName "sophos" -Offer "sophos-xg" -Skus "Linux (sfos 19)"

# If the plan exists in the Destination Subscription, then you need to accept the terms and conditions of the Marketplace VM.
# Accept Terms of Marketplace VM at Destination Subscription (Powershell)
 
Get-AzMarketplaceTerms -Publisher "fortinet" -Product "fortinet_fortigate-vm_v5" -Name "fortinet_fg-vm_payg_20190624" -OfferType 'fortinet_fortigate-vm_v5' | Set-AzMarketplaceTerms -Accept
 
