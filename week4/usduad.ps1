$loginouts = Get-EventLog -LogName Security -InstanceId 4624, 4634 -After (Get-Date).AddDays(-14)

$loginoutsTable = @()
for ($i = 0; $i -lt $loginouts.Count; $i++) {
    $Event = if ($loginouts[$i].InstanceId -eq 4624) { "Logon" } else { "Logoff" }
    
    $User = $loginouts[$i].ReplacementStrings[5]
    
    $loginoutsTable += [PSCustomObject]@{
        "Time" = $loginouts[$i].TimeGenerated
        "Id" = $loginouts[$i].InstanceId
        "Event" = $Event
        "User" = $User
    }
}

$loginoutsTable
