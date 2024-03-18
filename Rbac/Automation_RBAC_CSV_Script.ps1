#Import-Module Az.Resources
#Connect-AzAccount -UseDeviceAuthentication -SubscriptionId 'xxxx-xxxx'
$csv = Import-Csv -Path "Rbac\sid-123.csv"
$k = Get-ChildItem  D:\PoweshellScripts\PowerShell_Automation 
$p = 0
foreach ($row in $csv) {
  $p = $p + 1;
  $row | Add-Member -NotePropertyName 'RowNo' -NotePropertyValue $p
  $test1 = $row.RowNo
  $test1
  #$xyz = $row.RoleDefinitionId
  $row.RoleDefinitionId = $row.RoleDefinitionId.Substring(102); 
}
$exportPath = "D:\PoweshellScripts\PowerShell_Automation\Rbac\temp_outputi_folder"
$csv | Export-Csv 'output11.csv' -Path $exportPath -NoTypeInformation
"Kya be !!!! samjha kya"
$k
