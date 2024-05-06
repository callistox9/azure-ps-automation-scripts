$sourceSubId = "292125ed-7081-4c35-b3e0-65b69b51fd39";
$destSubId = "1234-567we89-01wf2gg34";
$csv = Import-Csv -Path ".\Rbac\test_csv_files\role-assignments-2024-05-06.csv";

foreach ($row in $csv) {
  $scope = $row.Scope;
  if ($scope -match $sourceSubId ) {
    $newValue = $scope -replace $sourceSubId, $destSubId
    $row.Scope = $newValue
  }
} 
$csv | Export-Csv -Path Rbac\temp_outputi_folder\2changedScope.csv 