Import-Module Az.Resources
Connect-AzAccount -UseDeviceAuthentication 
$csv = Import-Csv -Path ".\role-assignments-2024-03-14.csv"

#Loop to iterate between all rows in the csv file.

foreach ($row in $csv) {
  $ObjectId = $row.ObjectId
  $RoleDefinitionId = $row.RoleDefinitionId;
  $Scope = $row.Scope
  $RoleDefinitionName = $row.RoleDefinitionName
  $SignInName = $row.SignInName
  $RowNo = $row.RowNo

  #Test condition to check whether roleDefination is null or not.

  if (-not [string]::IsNullOrEmpty($RoleDefinitionId)) {
        
    #Command to execute the role assignments.
    
    New-AzRoleAssignment  -RoleDefinitionId $RoleDefinitionId -ObjectId $ObjectId -Scope $Scope
  }
  else {
    #Displays warnig if the respective roleDefinitingId is null, thus jumps to another execution.
    Write-Error "RoleDefinition Id for the current iteration is undefined"
    Write-Warning "RoleDefinitionid is null or empty for this user/servicePrincipals/groups/directoryObjects. Skipping..." 
    #Displays RowNo at which the RoleDefinitionId is null
    "The specific row has null RoleDefinitionId"
    "RowNo ---------------" + $RowNo
    Write-Error "SignInName---RoleDefinitionName"
    #Displays the SignInName and RoleDefinitionName of the respective row iteration
    "SignInName ----------" + $SignInName 
    "RoleDefinitionName --" + $RoleDefinitionName
    Write-Error "*****************************************"
  }
}


