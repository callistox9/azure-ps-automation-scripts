#Import-Module Az.Resources
#Connect-AzAccount -UseDeviceAuthentication 
$csv = Import-Csv -Path "Rbac\sid-123.csv"

#Loop to iterate between all rows in the csv file.
$p = 0
foreach ($row in $csv) {
  $ObjectId = $row.ObjectId
  $RoleDefinitionId = $row.RoleDefinitionId;
  $Scope = $row.Scope
  $RoleDefinitionName = $row.RoleDefinitionName
  $SignInName = $row.SignInName
  
  $p = $p + 1;
  $row | Add-Member -NotePropertyName 'RowNo' -NotePropertyValue $p
  $RowNo = $row.RowNo
  #$test1 = $row.test1
  #$test1
  #$RoleDefinitionId = $row.RoleDefinitionId
  #$RoleDefinitionId.Substring(102); 
  try {
    # Assuming RoleDefinitionId is a string, you're trying to substring it
    $RoleDefinitionId.Substring(102)
  }
  catch {
    Write-Host "Error occurred while processing RoleDefinitionId: $_"
    # Log the error, or handle it as needed
  }

  $RoleDefinitionId.Substring(102)
  #Test condition to check whether roleDefination is null or not.

  
}


