function Get-ApacheAccessLogs {
    param (
        [string]$logFilePath = "C:\Users\champuser\SYS320-01\week8\access.log"
    )

    $logLines = Get-Content -Path $logFilePath

    $logEntries = @()

    foreach ($line in $logLines) {
        $parts = $line -split '\s+'

        if ($parts.Count -ge 10) {
            $IP = $parts[0]

            $rawTime = $line.Substring($line.IndexOf("[") + 1, $line.IndexOf("]") - $line.IndexOf("[") - 1)
            $Time = $rawTime.Split(" ")[0]

            $Method = $parts[5].Trim('"')
            $Page = $parts[6]
            $Protocol = $parts[7].Trim('"')

            $Response = $parts[8]

            $referrerStartIndex = $line.IndexOf('"', $line.IndexOf('"', $line.IndexOf('"') + 1) + 1)
            $referrerEndIndex = $line.IndexOf('"', $referrerStartIndex + 1)
            $Referrer = $line.Substring($referrerStartIndex, $referrerEndIndex - $referrerStartIndex + 1) # Keep quotes

            $logEntries += [pscustomobject]@{
                IP       = $IP
                Time     = $Time
                Method   = $Method
                Page     = $Page
                Protocol = $Protocol
                Response = $Response
                Referrer = $Referrer
            }
        }
    }

    $logEntries | Format-Table -AutoSize
}

Get-ApacheAccessLogs -logFilePath "C:\Users\champuser\SYS320-01\week8\access.log"
