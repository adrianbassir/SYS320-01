function Get-ApacheAccessLogsWithIndicators {
    param (
        [string]$logFilePath = "C:\Users\champuser\SYS320-01\week8\access.log",
        [string[]]$indicators
    )

    # Read all log lines from the file
    $logLines = Get-Content -Path $logFilePath

    # Array to hold parsed log entries
    $logEntries = @()

    foreach ($line in $logLines) {
        # Split the line into parts based on spaces
        $parts = $line -split '\s+'

        # Ensure that the line has at least the basic structure (IP, Time, Method, Page, Protocol, Response, Referrer)
        if ($parts.Count -ge 10) {
            $IP = $parts[0]

            # Extracting the timestamp (enclosed in square brackets) and removing the timezone
            $rawTime = $line.Substring($line.IndexOf("[") + 1, $line.IndexOf("]") - $line.IndexOf("[") - 1)
            $Time = $rawTime.Split(" ")[0]  # Get everything before the space to remove the timezone

            # HTTP request method, page, and protocol (request details enclosed in quotes)
            $Method = $parts[5].Trim('"')
            $Page = $parts[6]
            $Protocol = $parts[7].Trim('"')

            # HTTP response code (the status code)
            $Response = $parts[8]

            # Only include logs with Response 200
            if ($Response -ne "200") {
                continue # Skip if the response code is not 200
            }

            # Extract the referrer, which is after the response size, including the quotes
            $referrerStartIndex = $line.IndexOf('"', $line.IndexOf('"', $line.IndexOf('"') + 1) + 1)
            $referrerEndIndex = $line.IndexOf('"', $referrerStartIndex + 1)
            $Referrer = $line.Substring($referrerStartIndex, $referrerEndIndex - $referrerStartIndex + 1) # Keep quotes

            # Check if any of the indicators appear in the Page property
            $containsIndicator = $false
            foreach ($indicator in $indicators) {
                if ($Page -like "*$indicator*") {
                    $containsIndicator = $true
                    break
                }
            }

            # Only add the log entry if it contains one of the indicators in the Page property
            if ($containsIndicator) {
                $logEntries += [pscustomobject]@{
                    IP       = $IP
                    Time     = $Time  # Time without the timezone
                    Method   = $Method
                    Page     = $Page
                    Protocol = $Protocol
                    Response = $Response
                    Referrer = $Referrer  # Keep the quotes
                }
            }
        }
    }

    # Display the filtered log entries as a formatted table
    $logEntries | Format-Table -AutoSize
}

# Example of how to call the function with a list of indicators
Get-ApacheAccessLogsWithIndicators -logFilePath "C:\Users\champuser\SYS320-01\week8\access.log" -indicators @("/index.html", "/index.php")
