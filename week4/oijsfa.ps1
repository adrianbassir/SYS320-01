function Get-LogonLogoffEvents {
    param(
        [int]$DaysBack
    )
    
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Please run PowerShell as Administrator."
        return
    }

    try {
        $loginouts = Get-EventLog -LogName Security -InstanceId 4624, 2634 -After (Get-Date).AddDays(-$DaysBack) -ErrorAction Stop
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

        try {
            $sid = New-Object System.Security.Principal.SecurityIdentifier($log.ReplacementStrings[1]) # Ensure this is the correct index for SID
            $user = $sid.Translate([System.Security.Principal.NTAccount]).Value
        } catch {
            $user = "Unknown User"
            Write-Host "Failed to translate SID: $($_.Exception.Message)"
        }

        $loginoutsTable += [PSCustomObject]@{
            Time = $log.TimeGenerated
            Id = $log.InstanceId
            Event = $event
            User = $user
        }
    }

    return $loginoutsTable
}

$days = 30
$result = Get-LogonLogoffEvents -DaysBack $days
$result | Format-Table -AutoSize
