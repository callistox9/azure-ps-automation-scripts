Import-Module Az.Resources
Connect-AzAccount -UseDeviceAuthentication -SubscriptionId "XXXX-XXXX-XXXX"
$csv = Import-Csv -Path ".\RG.csv"

foreach ($row in $csv) {
  $ResourceGrpName = $row.RESOURCEGROUP
  $Location = $row.Location

  New-AzResourceGroup -Name $ResourceGrpName -Location $Location
}