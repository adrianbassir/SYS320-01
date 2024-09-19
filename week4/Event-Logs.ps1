function Get-LogonLogoffEvents {
    param([int]$DaysBack)

    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Please run PowerShell as Administrator."
        return
    }

    try {
        $loginouts = Get-EventLog -LogName Security -InstanceId 7001, 7002 -After (Get-Date).AddDays(-$DaysBack) -ErrorAction Stop
    } catch {
        Write-Host "Failed to retrieve events: $($_.Exception.Message)"
        return
    }

    if ($loginouts.Count -eq 0) {
        Write-Host "No logon or logoff events found with the specified IDs in the last $DaysBack days."
        return
    }

    $loginoutsTable = @()

    foreach ($log in $loginouts) {
        $event = if ($log.InstanceId -eq 7001) { "Logon" } else { "Logoff" }
        $user = "System"

        $loginoutsTable += [PSCustomObject]@{
            Time = $log.TimeGenerated
            Id = $log.EventID
            Event = $event
            User = $user
        }
    }

    return $loginoutsTable
}

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
        $eventType = if ($event.InstanceId -eq 6005) { "Startup" } else { "Shutdown" }

        $eventsTable += [PSCustomObject]@{
            Time = $event.TimeGenerated
            Id = $event.EventID
            Event = $eventType
            User = "System"
        }
    }

    return $eventsTable
}
