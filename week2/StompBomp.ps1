cd $PSScriptRoot
$files=(Get-ChildItem)

$folderpath = "$PSScriptRoot/outfolder/"
$filePath = Join-Path -Path $folderpath "out.csv"

$files | Where-Object {$_.Extension -eq ".ps1" } | 
Export-Csv -Path $filePath