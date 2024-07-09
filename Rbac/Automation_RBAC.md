# Overview

This project is designed to automate the migration of role assignments from one Azure subscription to another. The script processes a CSV file containing role assignment details, modifies the subscription ID in the scope, and then assigns the roles in the new subscription.

#### Prerequisites

Azure PowerShell Module: Ensure the Az.Resources module is installed.

`
Install-Module -Name Az.Resources -AllowClobber -Force`
Azure Subscription: You need to have permissions to create role assignments in both the source and destination subscriptions.
How to Use

#### Step 1: Authentication

The script starts by importing the required Azure module and authenticating to your Azure account. Replace 'xxxx-xxxx' with your actual subscription ID.

`
Import-Module Az.Resources
Connect-AzAccount -UseDeviceAuthentication -SubscriptionId 'xxxx-xxxx'`

#### Step 2: Import CSV

Import the CSV file containing role assignments. The path to the CSV file should be adjusted as necessary.

`$csv = Import-Csv -Path ".\role-assignments-2024-03-14.csv"`

#### Step 3: Variables Initialization

Set the source and destination subscription IDs.

#### Dummy variable value for testing

`$sourceSubId = "292125ed-7081-4c35-b3e0-65b69b51fd39"
$destSubId = "1234-567we89-01wf2gg34"`

#### Count Variable

`
$p = 0`

#### Step 4: Process CSV Rows

Loop through each row in the CSV file, replace the source subscription ID with the destination subscription ID in the scope, and add a row number.

`foreach ($row in $csv) {
  $scope = $row.Scope
  if ($scope -match $sourceSubId) {
$newValue = $scope -replace $sourceSubId, $destSubId
$row.Scope = $newValue
}
$p = $p + 1
$row | Add-Member -NotePropertyName 'RowNo' -NotePropertyValue $p
$row.RoleDefinitionId = $row.RoleDefinitionId.Substring(102)
}`

#### Step 5: Assign Roles

For each row in the modified CSV, check if the RoleDefinitionId is not null or empty, and if valid, create the new role assignment. If invalid, log the error and warning messages.

`foreach ($row in $csv) {
$ObjectId = $row.ObjectId
$RoleDefinitionId = $row.RoleDefinitionId
$Scope = $row.Scope
$RoleDefinitionName = $row.RoleDefinitionName
$SignInName = $row.SignInName
$RowNo = $row.RowNo`

`if (-not [string]::IsNullOrEmpty($RoleDefinitionId)) {
New-AzRoleAssignment -RoleDefinitionId $RoleDefinitionId -ObjectId $ObjectId -Scope $Scope
} else {
Write-Error "RoleDefinitionId for the current iteration is undefined"
Write-Warning "RoleDefinitionId is null or empty for this user/servicePrincipals/groups/directoryObjects. Skipping..."
"The specific row has null RoleDefinitionId"
"RowNo ---------------" + $RowNo
Write-Error "SignInName---RoleDefinitionName"
"SignInName ----------" + $SignInName
"RoleDefinitionName --" + $RoleDefinitionName
Write-Error "**\*\*\*\***\*\*\*\***\*\*\*\***\***\*\*\*\***\*\*\*\***\*\*\*\***"
}
}`

# Notes

The script processes and assigns roles in two separate loops for better readability and understanding.
Ensure the CSV file follows the required format and includes necessary columns: ObjectId, RoleDefinitionId, Scope, RoleDefinitionName, and SignInName.
Test the script in a non-production environment before running it in production to avoid unintended changes.

# Contributing

Feel free to contribute by submitting a pull request. For major changes, please open an issue first to discuss what you would like to change.
