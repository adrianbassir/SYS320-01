. "$PSScriptRoot\Event-Logs.ps1"

Clear-Host

$LogInOutsTable = Get-LogonLogoffEvents -DaysBack 15
$LogInOutsTable | Format-Table -AutoSize | Out-String -Width 4096 | Write-Host

$ShutdownsTable = Get-StartupShutdownEvents -DaysBack 25 | Where-Object {$_.Event -eq "Shutdown"}
$ShutdownsTable | Format-Table -AutoSize | Out-String -Width 4096 | Write-Host

$StartupsTable = Get-StartupShutdownEvents -DaysBack 25 | Where-Object {$_.Event -eq "Startup"}
$StartupsTable | Format-Table -AutoSize | Out-String -Width 4096 | Write-Host
