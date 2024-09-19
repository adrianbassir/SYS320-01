function Get-StartupShutdownEvents {
    param([int]$DaysBack)
    
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Please run PowerShell as Administrator."
        return
    }

    try {
        $events = Get-EventLog -LogName System -InstanceId 6005, 6006 -After (Get-Date).AddDays(-$DaysBack) -ErrorAction Stop
    } catch {
        Write-Host "Failed to retrieve events: $($_.Exception.Message)"
        return
    }

    if ($events.Count -eq 0) {
        Write-Host "No startup or shutdown events found with the specified IDs in the last $DaysBack days."
        return
    }

    $eventsTable = @()
    foreach ($event in $events) {
        $eventType = switch ($event.InstanceId) {
            6005 { "Startup" }
            6006 { "Shutdown" }
            default { "Unknown" }
        }

        $eventsTable += [PSCustomObject]@{
            Time = $event.TimeGenerated
            Id = $event.EventID
            Event = $eventType
            User = "System"
        }
    }

    return $eventsTable
}

$days = 30
$result = Get-StartupShutdownEvents -DaysBack $days
$result | Format-Table -AutoSize
