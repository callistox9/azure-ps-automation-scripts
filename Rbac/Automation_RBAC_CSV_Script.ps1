Import-Module Az.Resources
Connect-AzAccount -UseDeviceAuthentication -SubscriptionId "xxxx-xxxx-xxxx"
$csv = Import-Csv -Path ".\role-assignments-2024-03-14.csv"

#Count Variable
$p = 0  
#Loop to iterate between all rows in the csv file.
foreach ($row in $csv) {

  $p = $p + 1;
  
  #Adding a column to each row and assinging the value of $p to it.
  
  $row | Add-Member -NotePropertyName 'RowNo' -NotePropertyValue $p

  #Deleting the first 102 characters from the RoleDefinitionId string
  #Thus keeping only the last 32 Digit GUID value of the default RoleDefinitionId
  
  $row.RoleDefinitionId = $row.RoleDefinitionId.Substring(102);
}

foreach ($row in $csv) {
  #Storing respective column values of the current row in respective variables 
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
    Write-Error "RoleDefinitionId for the current iteration is undefined"
    Write-Warning "RoleDefinitionId is null or empty for this user/servicePrincipals/groups/directoryObjects. Skipping..." 
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

# The maninulation of CSV as well as assigning RBACs could be done in a single loop,
# But for better understanding, developers can easily read the code.


