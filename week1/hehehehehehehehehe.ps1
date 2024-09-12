$files = Get-ChildItem -Recurse -Filter *.csv
$files | Rename-Item -NewName { $_.Name -replace '.csv', '.log' }
Get-ChildItem -Recurse