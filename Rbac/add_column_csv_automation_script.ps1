#Import-Module Az.Resources
#Connect-AzAccount -UseDeviceAuthentication -SubscriptionId 'xxxx-xxxx'
#The above comments need not to be commented out if working in a live environment as-
#needed for authentication and performing tasks

#Importing test-CSV  
$csv = Import-Csv -Path "Rbac\sid-123.csv" 

$p = 0 #Count Variable 
foreach ($row in $csv) {
  $p = $p + 1;
  
  #Adding a column to each row and assinging the vale of $p to it.
  
  $row | Add-Member -NotePropertyName 'RowNo' -NotePropertyValue $p

  #Deleting the first 102 characters from the RoleDefinitionId string
  #Thus keeping only the last 32 Digit GUID value of the default RoleDefinitionId

  $row.RoleDefinitionId = $row.RoleDefinitionId.Substring(102); 

}
#Saved to file in the current working directory
$csv | Export-Csv  "column_added_csv" -NoTypeInformation
