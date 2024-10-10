function ApacheLogs1 {

    # Read the last 10 entries from the Apache log file
    $logsNotFormatted = Get-Content "C:\xampp\apache\logs\access.log" | Select-Object -Last 10
    $tableRecords = @()

    # Parse each log entry into a custom object
    foreach ($log in $logsNotFormatted) {
        # Split the log entry into components
        $words = $log -split " "

        # Create a custom object with the desired fields
        $tableRecords += [pscustomobject]@{
            "IP"        = $words[0]
            "Time"      = $words[3].TrimStart('[')
            "Method"    = $words[5].Trim('"')
            "Page"      = $words[6]
            "Protocol"  = $words[7].Trim('"')
            "Response"  = $words[8]
            "Referrer"  = $words[10].Trim('"')
            "Client"    = $words[11].Trim('"')
        }
    }

    # Display the records in a table format
    $tableRecords | Format-Table -AutoSize -Wrap
}
